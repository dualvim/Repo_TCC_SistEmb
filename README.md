# Repositório com os projetos pertinentes à monografia em Sistemas Embarcados        
 - Arquivos referentes ao projeto da **MONOGRAFIA** do aluno **Eduardo Alvim Guedes Alcoforado** ([Currículo Lattes](http://lattes.cnpq.br/0205554239317512)).      
 - Titulo do trabalho: "**Utilização de FPGA no Desenvolvimento de um Microcontrolador de 32 Bits com Arquitetura RISC-V e Conjunto de instruções RV32IM**".       
 - Faculdade de Tecnologia **SENAI "Anchieta"**.     
 - Curso de **Pós-Graduação em Sistemas Embarcados** - **Turma 6** - **6SE**.      
 - Orientador: **Prof. Dr. Leandro Poloni Dantas** ([Currículo Lattes](http://lattes.cnpq.br/6255986062207024)).      
 - Arquivo **`Artigo_EduardoAlvim_V10_ABNT_final.pdf`**: Arquivo com o artigo entregue para a banca de defesa.       
           

# Projetos disponíveis nesse repositório:      
 - Sobre os projetos disponíveis nesse repositório:       
 - Linguagens utilizadas: **Verilog** e **SystemVerilog**.      
	- Projetos gerados usando a ferramenta Intel **Quartus Prime 20.1.1 - Lite Edition**.      
	- Os projetos desse repositório foram desenvolvidos para serem implementados em CIs FPGA da família Max 10 da Altera/Intel).      
	- Os projetos aqui foram testados em um kit FPGA **Terasic DE10-Lite**.     
	- Esse kit contém o CI FPGA **10M50DAF484C7G**.        
 - Compilação dos **scripts em Assembly RISC-V**:    
	- Compilados usando o compilador e simulador **RARS**.       
	- O RARS é uma ferramenta gratuita e pode ser baixado [aqui](https://github.com/TheThirdOne/rars/releases).     
 - A **DOCUMENTAÇÃO COMPLETA** de todos os módulos do projeto está disponível na pasta **`DocumentacaoProj`**.      
	- Nomes dos módulos dentro de cada um dos arquivos do **projeto** da pasta **`Proj_RV32IM_02_De10Lite`**.    
	- Descrição de cada um dos módulos apresentados.      
	- Especificação das constantes, entradas e saídas de cada um dos módulos.     
	- Código do módulo em Verilog ou SystemVerilog.         
          

# Pastas com os projetos:      
 - Pasta **`Proj_RV32I_01_ALU_RISC-V`**:       
	- Implementação básica da ALU (_Arithmetic Logic Unit_) da CPU RISC-V.     
	- Os testes das instruçõesx processadas na ALU são realizados de forma manual (ver o vídeo).       
 - Pasta **`Proj_RV32IM_02_De10Lite`**:     
	- Implementação da CPU RISC-V com o conjunto de instruções **RV32IM**.     
	- O código não está 100%, mas todo o conteúdo prioritário está pronto e funcionando.      
	- Os **testes** do hardware implementado são realizados por meio do arquivo **`testbench.sv`**.      
	- **Esse projeto é testado no ModelSim**.      
- Pasta **`Proj_RV32IM_03_De10Lite`**:     
	- Implementação da CPU RISC-V com o conjunto de instruções **RV32IM**.     
	- Esse projeto inclui o carregamento dos programas em Assembly RISC-V na memória de programa.      
	- Esse projeto é carregado no kit FPGA e o conteúdo da RAM verificado na ferramenta "_In-System Memory Content Editor_" do Quartus.      
 - Pasta **`Scripts_asm`**:     
	- Scripts em Assembly RISC-V com programas usados para testar os projeto que cria uma CPU RISC-V.         
	- Os arquivos com os programas compilados foram gerados por meio do software RARS.       
	 
---      
        
# Agradecimentos:      
 - [Diego Salviano Nagai](https://github.com/diegonagai), da 7a urma da Pós-Graduação em Sistemas Embarcados (7SE).        
        
	 
---      
        
	 
|    |    |
| :---: | :---: |
| ![SENAI](./Imagens/Logo_SENAI.jpg) | ![RISC-V](./Imagens/logo_riscv.png) |
| ![Quartus Prime](./Imagens/Logo_Quartus.png) | ![Altera e Intel](./Imagens/Logo_Intel_Altera.jpg) |
| ![MAX 10](./Imagens/Logo_Max10_Altera.jpg) | ![MAX 10](./Imagens/Logo_MAX10_Intel.png) |
        