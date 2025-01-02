from rvvsuite import simulator
import os

TESTS_DIR = 'tests'
OUTPUT_DIR = 'golden_model'
CONFIGS = {
    'pc_width': 10,
    'addr_width': 12,
    'elen': 32,
    'vlen': 128,
    'cycle': 10,
    'cycle_offset': 1,
}

def load_imem(file_path):
    imem = {}
    
    with open(file_path, 'r') as file:
        address = 0
        for line in file:
            binary_string = line.strip()
            if not binary_string:
                continue
            icb_value = int(binary_string, 2)
            imem[address] = icb_value
            address += 4

    return imem


def load_dmem(file_path):
    dmem = {}
    
    with open(file_path, 'r') as file:
        address = 0
        for line in file:
            binary_string = line.strip()
            if not binary_string:
                continue
            icb_value = int(binary_string, 2)
            dmem[address] = icb_value
            address += 1

    return dmem


def main():
    if not os.path.isdir(TESTS_DIR):
        print(f"ERROR: {TESTS_DIR=} not exist.")
        exit(-1)

    tests = sorted(set(os.listdir(TESTS_DIR)))

    for test in tests:
        imem = load_imem(f'{TESTS_DIR}/{test}/imem.mem')
        dmem = load_dmem(f'{TESTS_DIR}/{test}/dmem.mem')
        
        # Run simulation
        sim = simulator(imem, dmem, CONFIGS)
        changelog = sim.run()

        os.makedirs(f'{OUTPUT_DIR}/{test}', exist_ok=True)

        f_pc = open(f'{OUTPUT_DIR}/{test}/pc.log', 'w')
        f_xreg = open(f'{OUTPUT_DIR}/{test}/xreg.log', 'w')
        f_vreg = open(f'{OUTPUT_DIR}/{test}/vreg.log', 'w')
        f_dmem = open(f'{OUTPUT_DIR}/{test}/dmem.log', 'w')

        cycle = CONFIGS['cycle']

        # Write changes to logs
        for i, change in enumerate(changelog):
            i += CONFIGS['cycle_offset']
            f_pc.write(f'Time={i * cycle} ')
            f_pc.write(f'PC=0x{hex(change['pc'])[2:].zfill(CONFIGS["pc_width"])}\n')

            if 'x_reg_file' in change:
                x_reg_file_change = change['x_reg_file']
                for j, value in x_reg_file_change.items():
                    f_xreg.write(f'Time={i * cycle} ')
                    f_xreg.write(f'XRF[{j}]=0x{hex(value)[2:].zfill(CONFIGS["elen"] // 4)}\n')

            if 'v_reg_file' in change:
                v_reg_file_change = change['v_reg_file']
                for j, value in v_reg_file_change.items():
                    f_vreg.write(f'Time={i * cycle} ')
                    f_vreg.write(f'VRF[{j}]=0x{hex(value)[2:].zfill(CONFIGS["vlen"] // 4)}\n')

            if 'dmem' in change:
                dmem_change = change['dmem']
                for addr, value in sorted(dmem_change.items()):
                    f_dmem.write(f'Time={i * cycle} ')
                    f_dmem.write(f'DMEM[{addr}]=0x{hex(value)[2:].zfill(8 // 4)}\n')

        f_pc.close()
        f_xreg.close()
        f_vreg.close()
        f_dmem.close()

        break


if __name__ == '__main__':
    main()