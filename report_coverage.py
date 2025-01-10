import os
import json
import matplotlib.pyplot as plt
from collections import defaultdict
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
import numpy as np

SIM_DIR = 'golden_model'
OUT_DIR = 'coverage_report'
CONFIGS_FILE = 'configs.json'

def draw_read_write_bar_chart(data, title, xlabel, ylabel, filename):
    fig, ax = plt.subplots(figsize=(12, 6))

    # Bar positions with space between them
    bar_width = 0.35
    index = [i * 1.5 for i in range(len(data))]

    # Plot the reads and writes for each instruction
    ax.bar(index, [d['reads'] for d in data.values()], width=bar_width, label='Reads', color='blue')
    ax.bar([i + bar_width for i in index], [d['writes'] for d in data.values()], width=bar_width, label='Writes', color='red')

    # Labels and title with font customization
    title_font = {'fontname': 'Arial', 'fontsize': 16}
    label_font = {'fontname': 'Arial', 'fontsize': 14}
    tick_font = {'fontsize': 12}

    ax.set_title(title, fontdict=title_font)
    ax.set_xlabel(xlabel, fontdict=label_font)
    ax.set_ylabel(ylabel, fontdict=label_font)
    ax.set_xticks([i + bar_width / 2 for i in index])  # Center labels between the bars
    ax.set_xticklabels(data.keys(), rotation=90, ha='center', fontdict=tick_font)

    # Add legend
    ax.legend()

    # Save figure
    fig.tight_layout()
    fig.savefig(filename)
    plt.close(fig)


def draw_pie_chart(data, title, filename):
    fig, ax = plt.subplots(figsize=(8, 8))
    ax.pie(data.values(), labels=data.keys(), autopct='%1.1f%%', startangle=90)
    ax.axis('equal')  # Equal aspect ratio ensures the pie chart is circular.
    ax.set_title(title)
    fig.savefig(filename)
    plt.close(fig)


def draw_vector_column_chart(inst_data, title, xlabel, ylabel, filename):
    fig, ax = plt.subplots(figsize=(16, 8))
    index = range(len(inst_data))
    ax.bar(index, inst_data.values(), color='blue')
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    ax.set_xticks(index)
    ax.set_xticklabels(inst_data.keys(), rotation=45, ha='right')
    fig.tight_layout()
    fig.savefig(filename)
    plt.close(fig)


def main():
    if not os.path.isdir(SIM_DIR):
        print(f"ERROR: {SIM_DIR} does not exist.")
        exit(-1)

    # Initialize a defaultdict to accumulate stats
    aggregated_stats = defaultdict(lambda: defaultdict(int))

    # List and sort all test directories
    tests = sorted(os.listdir(SIM_DIR))

    for test in tests:
        with open(f'{SIM_DIR}/{test}/stats.json', 'r') as f:
            stats = json.load(f)

            # Sum up 'scalar_insts', 'vector_insts', 'vector_reads', 'vector_writes', 'register_reads', and 'register_writes'
            for key, value in stats.items():
                for sub_key, sub_value in value.items():
                    aggregated_stats[key][sub_key] += sub_value

    vector_usages = {f'v{v}': {
        'reads': aggregated_stats['vector_reads'][str(v)],
        'writes': aggregated_stats['vector_writes'][str(v)]
        } for v in range(32)
    }

    register_usages = {f'x{r}': {
        'reads': aggregated_stats['register_reads'][str(r)],
        'writes': aggregated_stats['register_writes'][str(r)]
        } for r in range(32)
    }

    # Calculate coverage
    num_of_vector_insts = len(aggregated_stats['vector_insts'])
    num_of_executed_vector_insts = sum(1 for value in aggregated_stats['vector_insts'].values() if value > 0)
    vector_inst_coverage = (num_of_executed_vector_insts / num_of_vector_insts) * 100

    num_of_used_vectors = sum(1 for v in range(32) if vector_usages[f'v{v}']['reads'] > 0 or vector_usages[f'v{v}']['writes'] > 0)
    vector_coverage = (num_of_used_vectors / 32) * 100

    num_of_used_registers = sum(1 for r in range(32) if register_usages[f'x{r}']['reads'] > 0 or register_usages[f'x{r}']['writes'] > 0)
    register_coverage = (num_of_used_registers / 32) * 100

    # Create output directory if it doesn't exist
    os.makedirs(OUT_DIR, exist_ok=True)

    # Draw charts

    draw_vector_column_chart(aggregated_stats['vector_insts'], 'Vector Instruction Usages', 'Instruction', 'Count', f'{OUT_DIR}/vector_insts_chart.png')
    draw_read_write_bar_chart(vector_usages, 'Vector Accesses (Reads/Writes)', 'Vector Register', 'Count', f'{OUT_DIR}/vector_access_chart.png')
    draw_read_write_bar_chart(register_usages, 'Registers Accesses (Reads/Writes)', 'Scalar Register', 'Count', f'{OUT_DIR}/register_access_chart.png')

    draw_pie_chart(aggregated_stats['vector_insts'], 'Instruction Distribution', f'{OUT_DIR}/inst_pie_chart.png')
    draw_pie_chart(aggregated_stats['vector_reads'], 'Vector Read Distribution', f'{OUT_DIR}/vector_read_pie_chart.png')
    draw_pie_chart(aggregated_stats['vector_writes'], 'Vector Write Distribution', f'{OUT_DIR}/vector_write_pie_chart.png')
    draw_pie_chart(aggregated_stats['register_reads'], 'Register Read Distribution', f'{OUT_DIR}/register_read_pie_chart.png')
    draw_pie_chart(aggregated_stats['register_writes'], 'Register Write Distribution', f'{OUT_DIR}/register_write_pie_chart.png')

    with open(CONFIGS_FILE, 'r') as config_file:
        configs = json.load(config_file)

    # Write the Markdown report
    report_file = os.path.join(OUT_DIR, 'report.md')
    with open(report_file, 'w') as f:
        f.write(f"# COVERAGE REPORT\n\n")
        
        # Vector Instruction Coverage
        f.write(f"**Vector Instructions**: {vector_inst_coverage:.2f}%\n\n")
        f.write(f"![Vector Instructions Column Chart](vector_insts_chart.png)\n\n")
        f.write(f"![Vector Instructions Pie Chart](inst_pie_chart.png)\n\n")
        
        # Vector Usage Coverage
        f.write(f"**Vectors**: {vector_coverage:.2f}%\n\n")
        f.write(f"![Vector Accesses Column Chart](vector_access_chart.png)\n\n")
        f.write(f"![Vector Read Pie Chart](vector_read_pie_chart.png)\n\n")
        f.write(f"![Vector Write Pie Chart](vector_write_pie_chart.png)\n\n")
        
        # Register Usage Coverage
        f.write(f"**Registers**: {register_coverage:.2f}%\n\n")
        f.write(f"![Register Accesses Column Chart](register_access_chart.png)\n\n")
        f.write(f"![Register Read Pie Chart](register_read_pie_chart.png)\n\n")
        f.write(f"![Register Write Pie Chart](register_write_pie_chart.png)\n\n")

        f.write(f"## Configurations\n\n")
        f.write(f"```json\n")
        json.dump(configs, f, indent=4)
        f.write(f"\n```\n")

    print(f"Coverage report saved to {report_file}")

if __name__ == '__main__':
    main()
