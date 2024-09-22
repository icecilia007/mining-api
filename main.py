import os
from datetime import datetime

# Definir variáveis fixas
VARIABLES_FIXAS = {
    'env': '',
    'project': 'Projectname',
    'author': '',
    'created': datetime.now().strftime('%Y-%m-%d'),
    'updated': datetime.now().strftime('%Y-%m-%d'),
    'version': '1.0.0',  # Definir a versão inicial
}


# Função para criar pastas
def create_folders():
    # Estrutura de diretórios
    dirs = [
        'infra/env/dev',
        'infra/env/staging',
        'infra/env/prod',
        'infra/modules/lambda',
        'infra/modules/lambda_image',
        'infra/modules/ecr',
        'infra/modules/s3',
        'infra/modules/glue',
        'infra/modules/stepfunction',
        'infra/modules/iam',
        'infra/modules/codebuild',
        'infra/modules/sns',
        'infra/modules/sqs',
        'infra/modules/db_athena',
        'infra/modules/workgroup_athena',
        'infra/modules/secretsmanager',
        'infra/modules/dynamodb',
        'infra/modules/ec2',
        'infra',
    ]

    files = [
        'main.tf',
        'variables.tf',
        'outputs.tf',
        'terraform.tfvars',
        'variables.tf',
        'backend.tf',
        'provider.tf',
        'versions.tf',
        'README.md',
    ]
    for dir in dirs:
        os.makedirs(dir, exist_ok=True)
        print(f'Diretório {dir} criado.')
        if dir.startswith('infra/modules'):
            for file in files[:3]:
                with open(f'{dir}/{file}', 'w', encoding='utf-8') as f:
                    if file == 'variables.tf':
                        f.write(
                            f'# -*- coding: utf-8 -*-\n'
                            f'# File name {dir}/{file}'
                            '\n\nvariable "TagProject" '
                            '{\n\ttype : string\n}'
                            '\n\nvariable "TagEnv" '
                            '{\n\ttype : string\n}'
                            '\n\nvariable "tags" '
                            '{\n\ttype : map(string)\n}'
                            '\n\nvariable "region" '
                            '{\n\ttype : string\n}'
                        )
                    elif file == 'outputs.tf':
                        f.write(
                            f'# -*- coding: utf-8 -*-\n'
                            f'# File name {dir}/{file}'
                            '\n\noutput "arn" {\n\tvalue = ""\n}\n'
                            '\n\noutput "name" {\n\tvalue = ""\n}\n'
                        )
                    else:
                        f.write(
                            f'# -*- coding: utf-8 -*-\n'
                            f'# File name {dir}/{file}'
                        )

        elif dir.startswith('infra/env'):
            with open(f'{dir}/{files[3]}', 'w', encoding='utf-8') as f:
                f.write(
                    f'# -*- coding: utf-8 -*-\n'
                    f'# File name {dir}/{files[3]}\n\n'
                    'TagProject= ""\n'
                    'TagEnv= ""\n'
                    'tags= {'
                    '\n\tenv = TagEnv'
                    '\n\tproject = TagProject'
                    '\n\tversion = "v1.0"'
                    '\n\t}'
                )
        elif dir == 'infra':
            for file in files[4:]:
                with open(f'{dir}/{file}', 'w', encoding='utf-8') as f:
                    if file == 'variables.tf':
                        f.write(
                            f'# -*- coding: utf-8 -*-\n'
                            f'# File name {file}'
                            '\n\nvariable "TagProject" '
                            '{\n\ttype : string\n}'
                            '\n\nvariable "TagEnv" '
                            '{\n\ttype : string\n}'
                            '\n\nvariable "tags" '
                            '{\n\ttype : map(string)\n}'
                            '\n\nvariable "region" '
                            '{\n\ttype : string\n}'
                        )
                    else:
                        f.write(f'# -*- coding: utf-8 -*-\n# File name {file}')


create_folders()
