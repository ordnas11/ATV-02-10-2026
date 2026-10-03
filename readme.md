<div align="center">
  <img src="https://cdn-icons-png.flaticon.com/512/3135/3135810.png" width="100" alt="Database Icon">
  <h1>🗳️ Urna Eletrônica - Modelagem de Dados</h1>
  <p><i>Estrutura Relacional com Regras de Integridade para Controle de Partidos, Candidatos, Eleitores, Presenças e Votos</i></p>

  [![Made with MySQL](https://img.shields.io/badge/Made_with-MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
  [![GitHub](https://img.shields.io/badge/GitHub-Repository-black?style=for-the-badge&logo=github)](#)
</div>

---

## 🗺️ Diagrama Entidade-Relacionamento (DER)

Abaixo está a representação visual do modelo de banco de dados, focando na filiação dos candidatos aos partidos, no controle de comparecimento do eleitor e na apuração dos votos por candidato, mantendo o voto separado da identidade de quem votou.

<div align="center">
  <img src="DER_urna_eletronica.png" alt="Visão Geral do Banco de Dados da Urna Eletrônica" width="850" style="border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.2);">
  <br>
  <i>(Certifique-se de que o arquivo DER_urna_eletronica.png esteja na mesma pasta que este README)</i>
</div>

---

## 📦 Entidades Principais

O banco `urna_eletronica` é composto por cinco tabelas, definidas no script SQL:

<table>
  <tr>
    <td align="center" width="120"><h1>🏛️</h1><b>partido</b></td>
    <td>Registra as legendas participantes: <code>numero_partido</code> (Chave Primária), <code>nome</code> e <code>sigla</code> (Garantida como única).</td>
  </tr>
  <tr>
    <td align="center"><h1>🧑‍💼</h1><b>candidato</b></td>
    <td>Armazena os concorrentes identificados pelo <code>numero_candidato</code> (Chave Primária), com <code>nome_completo</code>, <code>cargo</code>, <code>uf</code> e o partido ao qual pertencem (<code>numero_partido</code>, Chave Estrangeira).</td>
  </tr>
  <tr>
    <td align="center"><h1>🪪</h1><b>eleitor</b></td>
    <td>Mantém o cadastro de quem vota, identificado pelo <code>numero_titulo</code> (Chave Primária, <code>BIGINT</code>), com <code>nome</code>, <code>rg</code> (Garantido como único), <code>uf</code>, <code>cidade</code>, <code>zona</code> e <code>secao</code>.</td>
  </tr>
  <tr>
    <td align="center"><h1>✅</h1><b>registro_presenca</b></td>
    <td>Controla o comparecimento do eleitor à urna. O próprio <code>numero_titulo</code> é Chave Primária e Estrangeira, o que impede mais de um registro por eleitor, e <code>data_hora</code> guarda o momento do registro.</td>
  </tr>
  <tr>
    <td align="center"><h1>🗳️</h1><b>voto</b></td>
    <td>Registra cada voto computado através do <code>id_voto</code> (Chave Primária com <code>AUTO_INCREMENT</code>), com <code>data_hora</code> e o candidato escolhido (<code>numero_candidato</code>, Chave Estrangeira).</td>
  </tr>
</table>

---

## 🔗 Mapeamento de Relacionamentos (Foreign Keys)

A estrutura de relacionamentos (chaves estrangeiras) segue as seguintes regras de cardinalidade:

- <img src="https://cdn-icons-png.flaticon.com/512/148/148754.png" width="16"> **Partido ↔ Candidato:** Relação de um para muitos (`1:N`). Um partido possui vários candidatos `(candidato.numero_partido > partido.numero_partido)`.
- <img src="https://cdn-icons-png.flaticon.com/512/148/148754.png" width="16"> **Candidato ↔ Voto:** Relação de um para muitos (`1:N`). Um candidato pode receber vários votos `(voto.numero_candidato > candidato.numero_candidato)`.
- <img src="https://cdn-icons-png.flaticon.com/512/148/148754.png" width="16"> **Eleitor ↔ Registro de Presença:** Relação de um para um (`1:1`). Cada eleitor tem no máximo um registro de presença `(registro_presenca.numero_titulo - eleitor.numero_titulo)`.

> A tabela `voto` **não** referencia `eleitor`. Essa separação é proposital: a presença é registrada à parte, e não existe caminho no banco para ligar um voto a uma pessoa, preservando o sigilo do voto.

---

## 🛡️ Regras de Integridade (Constraints)

Além das chaves, o modelo aplica regras direto no banco para impedir dados inválidos:

| Tabela | Regra | O que garante |
|---|---|---|
| `partido` | `UNIQUE (sigla)` | Não existem duas legendas com a mesma sigla. |
| `partido` | `CHECK (numero_partido > 0)` | O número do partido é sempre positivo. |
| `candidato` | `CHECK (numero_candidato > 0)` | O número do candidato é sempre positivo. |
| `candidato` | `CHECK (cargo IN (...))` | O cargo só pode ser Deputado Federal, Deputado Estadual, Senador, Governador ou Presidente da Republica. |
| `candidato` | `CHECK` de `uf` por cargo | Candidato a Presidente deve ter `uf = 'BR'`; os demais cargos devem ter uma UF diferente de `'BR'`. |
| `eleitor` | `UNIQUE (rg)` | Não existem dois eleitores com o mesmo RG. |
| `eleitor` | `CHECK` de título, zona e seção | `numero_titulo`, `zona` e `secao` são sempre positivos. |

---

## 📝 Observações sobre o Modelo

Pontos de atenção para quem for executar ou evoluir o script:

- **Banco de dados:** o script começa com `USE urna_eletronica;`, então o banco precisa existir antes. Se necessário, rode `CREATE DATABASE urna_eletronica;` primeiro.
- **Versão do MySQL:** as cláusulas `CHECK` só são realmente aplicadas a partir do MySQL 8.0.16. Em versões anteriores elas são aceitas, mas ignoradas.
- **Número do candidato:** como `numero_candidato` é a Chave Primária sozinha, o mesmo número não pode se repetir entre cargos ou estados. Em eleições reais isso acontece, e uma chave composta (por exemplo, número + cargo + UF) resolveria.
- **Votos em branco e nulos:** `voto.numero_candidato` é `NOT NULL`, então esses casos não podem ser representados sem alterar o modelo.

---

## 👥 Participantes

Projeto desenvolvido por:

- **Sandro**
- **Vitor Froes**

---
<p align="center">
  <i>Desenvolvido para modelagem e documentação de estrutura de dados relacional.</i>
</p>
