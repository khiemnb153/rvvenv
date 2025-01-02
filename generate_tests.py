from rvvsuite import generator, assembler
import os

CONFIG_FILE = 'configs.json'
OUTPUT_DIR = 'tests'

def main():
    configs = generator.parse_config_file(CONFIG_FILE)

    num_of_test = configs['num_of_tests']
    test_prefix = configs['test_prefix']

    for i in range(num_of_test):
        ###### Generate assembly #######
        
        data_section, init_text_seq, main_text_seq = generator.generate(configs)
        assembly = generator.display(data_section, init_text_seq, main_text_seq)

        ################################

        ##### Retrive binary code ######
        
        text_section, data_section = assembler.sectionify(assembly)

        # Parse
        data = assembler.parse_data(data_section)
        text = assembler.parse_text(text_section, data)

        # Translate
        dmem = assembler.translate_data(data)
        imem = assembler.translate_text(text)

        ################################

        ############ Output ############

        os.makedirs(f'{OUTPUT_DIR}/{test_prefix}{i}', exist_ok=True)

        f = open(f'{OUTPUT_DIR}/{test_prefix}{i}/assembly.S', 'w')
        f.write(assembly)
        f.close()

        f = open(f'{OUTPUT_DIR}/{test_prefix}{i}/dmem.mem', 'w')
        f.write(dmem)
        f.close

        f = open(f'{OUTPUT_DIR}/{test_prefix}{i}/imem.mem', 'w')
        f.write(imem)
        f.close

        ################################


if __name__ == '__main__':
    main()
