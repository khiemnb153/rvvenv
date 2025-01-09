import os

SIMULATION_RESULT_DIR = 'verif/results'
GOLDEN_MODEL_DIR = 'golden_model'
RESULT_DIR = 'result'


def compare_line_by_line(file, ref):
    with open(file, 'r') as f, open(ref, 'r') as r:
        lines = f.read().splitlines()
        ref_lines = r.read().splitlines()

        if len(lines) != len(ref_lines):
            return False, 'File lengths differ' # is_identical, log

        for line_num, (line, ref_line) in enumerate(zip(lines, ref_lines), start=1):
            if line != ref_line:
                return False, f"Line {line_num}: '{line}'. Expected: '{ref_line}'"  # is_identical, log
            
        return True, ''


def check_test(test):
    result = True
    with open(f'{RESULT_DIR}/{test}.log', 'w') as failed_log:
        for file in ['pc', 'dmem', 'vreg', 'xreg']:
            part_result, log = compare_line_by_line(
                f'{SIMULATION_RESULT_DIR}/{test}/{file}.log',
                f'{GOLDEN_MODEL_DIR}/{test}/{file}.log',
            )
            if part_result == False:
                failed_log.write(f'{file}: {log}\n')
                result = part_result

    return result


def main():
    if not os.path.isdir(SIMULATION_RESULT_DIR):
        print(f"ERROR: {SIMULATION_RESULT_DIR=} not exist.")
        exit(-1)

    if not os.path.isdir(GOLDEN_MODEL_DIR):
        print(f"ERROR: {GOLDEN_MODEL_DIR=} not exist.")
        exit(-1)

    tests = set(os.listdir(SIMULATION_RESULT_DIR))
    refs = set(os.listdir(GOLDEN_MODEL_DIR))

    classified_tests = [
        (file, "UNTESTED" if file in refs and file not in tests
        else "TESTED" if file in refs and file in tests
        else "NO REF")
        for file in sorted(tests | refs)
    ]

    # Ensure result directory exists
    os.makedirs(RESULT_DIR, exist_ok=True)
    overall_log = open(RESULT_DIR + '/overall.log', 'w')
    
    for test, category in classified_tests:
        if category == "TESTED":
            result = check_test(test)
            overall_log.write(f"{test}: {'PASSED' if result else 'FAILED'}\n")
        else:
            overall_log.write(f'{test}: {category}\n')

    overall_log.close()


if __name__ == '__main__':
    main()