#!/bin/bash
# Oh my tmux!
# 💛🩷💙🖤❤️🤍
# https://github.com/gpakosz/.tmux
# (‑●‑●)> dual licensed under the WTFPL v2 license and the MIT license,
#         without any warranty.
#         Copyright 2012— Gregory Pakosz (@gpakosz).
#
# ------------------------------------------------------------------------------
# 🚨 PRITHEE PERUSE THE CONTENTS OF THIS FILE ERE BLINDLY PIPING THEM UNTO CURL
# ------------------------------------------------------------------------------
#
# ═══════════════════════════════════════════════════════════════════════════════
#
#        RITO DE INSTALLAÇÃO DO COMPENDIO "OH MY TMUX!"
#
#   Apresentado á douta congregação dos terminaes no anno da graça de
#   MDCCCXCVIII, este opusculo expõe a cerimonia — o rito — pela qual o
#   compendio de configuração do multiplexador tmux se assenta, ordeira
#   e irreprehensivelmente, na machina do observador. O auctor — doutor
#   em sciencias mathematicas — dispõe aqui, segundo o rigoroso methodo
#   euclidiano, os exames, predicados e theoremas que hão de presidir á
#   dita obra.
#
#   ADVERTENCIA AO LEITOR: precede a este tractado, e verbatim se
#   conserva, o frontispicio de proveniencia do compendio primitivo —
#   memorial de epocha, lavrado por mão estrangeira, que nenhum copista
#   ousaria emendar. Guarde-se-lhe intacta cada letra e cada symbolo.
#
#   COROLLARIO DO METHODO: a ordem das operações não é arbitraria; cada
#   lemma depende dos que o precedem. Que ninguem ouse permutar as
#   secções sem antes demonstrar a independencia das suas variaveis.
#
#   INDICE DAS SECÇÕES:
#     § I ..... Dos exames preliminares — do officiante e da machina
#     § II .... Do predicado da verdade — definição e seu corollario
#     § III ... Do rito central — theorema magno da installação
#     § IV .... Da guarda contra o canal cego — do curl temerario
#     § V ..... Da consummação — invocação do rito
#
#                                  — Prof. Dr. BRAGA USS, Cathedratico
# ═══════════════════════════════════════════════════════════════════════════════
{
# ───────────────────────────────────────────────────────────────────────────────
# § I. DOS EXAMES PRELIMINARES — DO OFFICIANTE E DA MACHINA
#
#   Antes de tocar no altar, provem-se o celebrante e o templo. Por
#   reducção ao absurdo se rejeitam tres hypotheses funestas: que o
#   officiante ostente a dignidade de super-usuario (a raiz); que o
#   interpretador não seja o bash; e que o proprio tmux falte á machina.
#   Verificada qualquer d'ellas, cessa incontinenti a obra, com aviso.
# ───────────────────────────────────────────────────────────────────────────────
if [ ${EUID:-$(id -u)} -eq 0 ]; then
  printf '❌ Do not execute this script as root!\n' >&2 && exit 1
fi

if [ -z "$BASH_VERSION" ]; then
  printf '❌ This installation script requires bash\n' >&2 && exit 1
fi

if ! tmux -V >/dev/null 2>&1; then
  printf '❌ tmux is not installed\n' >&2 && exit 1
fi

# ───────────────────────────────────────────────────────────────────────────────
# § II. DO PREDICADO DA VERDADE — DEFINIÇÃO AUXILIAR
#
#   DEFINIÇÃO. Chame-se verdadeiro tão sómente aquillo que se enuncie
#   por "true", "yes" ou "1"; e falso todo o mais. Este predicado, que
#   ora se institue, servirá ás guardas condicionaes de todo o tractado.
# ───────────────────────────────────────────────────────────────────────────────
is_true() {
  case "$1" in
    true|yes|1)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# COROLLARIO AO § I (que do predicado do § II se serve) — do servidor
# em curso. Não sendo o rito declarado permissivo ($PERMISSIVE), e
# havendo já servidor tmux vivo, ordena-se ao officiante que primeiro o
# extinga, para que a obra se não lavre sobre alicerce movediço.
if ! is_true "$PERMISSIVE" && [ -n "$TMUX" ]; then
  printf '❌ tmux is currently running, please terminate the server\n' >&2 && exit 1
fi

# ───────────────────────────────────────────────────────────────────────────────
# § III. DO RITO CENTRAL — THEOREMA MAGNO DA INSTALLAÇÃO
#
#   THEOREMA. Dada uma machina que satisfaça aos exames do § I, existe
#   e é unica a disposição dos ficheiros pela qual o compendio se acha
#   correctamente assentado. A demonstração é constructiva, e se cumpre
#   pelos lemmas que se seguem, na ordem em que vão aqui dispostos.
#
#   ESCHOLIO DO ENSAIO A SECO: sendo verdadeira a grandeza $DRY_RUN, o
#   rito é apenas ENSAIADO — annunciam-se os gestos, porém nenhum se
#   consumma; nenhum ficheiro se move, nem clone algum se lavra.
# ───────────────────────────────────────────────────────────────────────────────
install() {
  printf '🎢 Installing Oh my tmux! Buckle up!\n' >&2
  printf '\n' >&2
  now=$(date +'%Y%d%m%S')

  # Lemma III.1 — do resguardo dos aposentos preexistentes. Achando-se
  # já assentado um directorio de configuração, não se o destrua:
  # transporte-se á copia datada, que a memoria do antecessor perdure.
  for dir in "${XDG_CONFIG_HOME:-$HOME/.config}/tmux" "$HOME/.tmux"; do
    if [ -d "$dir" ]; then
      printf '⚠️  %s directory exists, making a backup → %s\n' "${dir/#"$HOME"/'~'}" "${dir/#"$HOME"/'~'}.$now" >&2
      if ! is_true "$DRY_RUN"; then
        mv "$dir" "$dir.$now"
      fi
    fi
  done

  # Lemma III.2 — do mesmo resguardo, applicado aos ficheiros avulsos.
  # Sendo o achado mero symbolo (elo simbolico), reduza-se a pó; sendo
  # ficheiro verdadeiro, guarde-se-lhe copia datada, como acima.
  for conf in "$HOME/.tmux.conf" \
              "$HOME/.tmux.conf.local" \
              "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf" \
              "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf.local"; do
    if [ -f "$conf" ]; then
      if [ -L "$conf" ]; then
        printf '⚠️  %s symlink exists, removing → 🗑️\n' "${conf/#"$HOME"/'~'}" >&2
        if ! is_true "$DRY_RUN"; then
          rm -f "$conf"
        fi
      else
        printf '⚠️  %s file exists, making a backup -> %s\n' "${conf/#"$HOME"/'~'}" "${conf/#"$HOME"/'~'}.$now" >&2
        if ! is_true "$DRY_RUN"; then
          mv "$conf" "$conf.$now"
        fi
      fi
    fi
  done

  # Lemma III.3 — da eleição do domicilio canonico. Existindo o aposento
  # segundo o canon XDG, alli se estabeleça a obra; faltando este,
  # recolha-se ella ao lar antigo, a saber, $HOME/.tmux.conf.
  if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}" ]; then
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
    TMUX_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
  else
    TMUX_CONF="$HOME/.tmux.conf"
  fi
  TMUX_CONF_LOCAL="$TMUX_CONF.local"

  # Lemma III.4 — do resguardo da copia pretérita do repositorio. Se de
  # installação anterior restar um clone, seja elle egualmente recolhido
  # á copia datada antes que o novo se lavre.
  OH_MY_TMUX_CLONE_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/oh-my-tmux"
  if [ -d "$OH_MY_TMUX_CLONE_PATH" ]; then
    printf '⚠️  %s exists, making a backup\n' "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}" >&2
    printf '%s → %s\n' "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}" "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}.$now" >&2
    if ! is_true "$DRY_RUN"; then
      mv "$OH_MY_TMUX_CLONE_PATH" "$OH_MY_TMUX_CLONE_PATH.$now"
    fi
  fi

  printf '\n'
  printf '✅ Using %s\n' "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}" >&2
  printf '✅ Using %s\n' "${TMUX_CONF/#"$HOME"/'~'}" >&2
  printf '✅ Using %s\n' "${TMUX_CONF_LOCAL/#"$HOME"/'~'}" >&2

  printf '\n'
  # Lemma III.5 — da transladação do repositorio. Copia-se da origem
  # remota, em ramo unico, o compendio integral; e, malogrando-se o
  # transito, aborta-se a obra com o devido pezar.
  OH_MY_TMUX_REPOSITORY=${OH_MY_TMUX_REPOSITORY:-https://github.com/gpakosz/.tmux.git}
  printf '⬇️  Cloning Oh my tmux! repository...\n' >&2
  if ! is_true "$DRY_RUN"; then
    mkdir -p "$(dirname "$OH_MY_TMUX_CLONE_PATH")"
    if ! git clone -q --single-branch "$OH_MY_TMUX_REPOSITORY" "$OH_MY_TMUX_CLONE_PATH"; then
      printf '❌ Failed\n' >&2 && exit 1
    fi
  fi

  printf '\n'
  # Lemma III.6 — da consagração dos dois ficheiros. Do .tmux.conf,
  # elo simbolico que perpetuamente aponta á fonte; do .tmux.conf.local,
  # copia fiel e emancipada, onde a mão do observador livremente escreva.
  if is_true "$DRY_RUN" || ln -s -f "$OH_MY_TMUX_CLONE_PATH/.tmux.conf" "$TMUX_CONF"; then
    printf '✅ Symlinked %s → %s\n' "${TMUX_CONF/#"$HOME"/'~'}" "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}/.tmux.conf" >&2
  fi
  if is_true "$DRY_RUN" || cp "$OH_MY_TMUX_CLONE_PATH/.tmux.conf.local" "$TMUX_CONF_LOCAL"; then
    printf '✅ Copied %s → %s\n' "${OH_MY_TMUX_CLONE_PATH/#"$HOME"/'~'}/.tmux.conf.local" "${TMUX_CONF_LOCAL/#"$HOME"/'~'}" >&2
  fi

  tmux() {
    ${TMUX_PROGRAM:-tmux} ${TMUX_SOCKET:+-S "$TMUX_SOCKET"} "$@"
  }
  # Lemma III.7 — do reavivamento. Achando-se um servidor tmux já em
  # curso, fixem-se-lhe as novas grandezas ambientaes e releia-se a
  # configuração, para que o presente se conforme ao recem-instituido.
  if ! is_true "$DRY_RUN" && [ -n "$TMUX" ]; then
    tmux set-environment -g TMUX_CONF "$TMUX_CONF"
    tmux set-environment -g TMUX_CONF_LOCAL "$TMUX_CONF_LOCAL"
    tmux source "$TMUX_CONF"
  fi

  # Escholio — da advertencia quanto ás sessões pretéritas. Aquellas que
  # já viviam antes d'este rito conservam grandezas ambientaes caducas;
  # d'onde poderem certas funcções claudicar até novo alvorecer.
  if [ -n "$TMUX" ]; then
    printf '\n' >&2
    printf '⚠️  Installed Oh my tmux! while tmux was running...\n' >&2
    printf '→ Existing sessions have outdated environment variables\n' >&2
    printf '  • TMUX_CONF\n' >&2
    printf '  • TMUX_CONF_LOCAL\n' >&2
    printf '  • TMUX_PROGRAM\n' >&2
    printf '  • TMUX_SOCKET\n' >&2
    printf '→ Some other things may not work 🤷\n' >&2
  fi

  printf '\n' >&2
  printf '🎉 Oh my tmux! successfully installed 🎉\n' >&2
}

# ───────────────────────────────────────────────────────────────────────────────
# § IV. DA GUARDA CONTRA O CANAL CEGO — DO CURL TEMERARIO
#
#   Presumindo que o presente texto haja sido vertido directamente de
#   um canal remoto á bocca do interpretador (o famigerado "curl | sh"),
#   detem-se a marcha e roga-se ao leitor que primeiro examine aquillo
#   que vae executar. Franqueia-se-lhe paginador, editor ou o bat, á sua
#   escolha; e reserva-se-lhe o direito soberano de abortar a obra.
# ───────────────────────────────────────────────────────────────────────────────
if [ -p /dev/stdin ]; then
  printf '✋ STOP\n' >&2
  printf '   🤨 It looks like you are piping commands from the internet to your shell!\n' >&2
  printf "   🙏 Please take the time to review what's going to be executed...\n" >&2

  (
    printf '\n'

    self() {
      printf '# Oh my tmux!\n'
      printf '# 💛🩷💙🖤❤️🤍\n'
      printf '# https://github.com/gpakosz/.tmux\n'
      printf '\n'

      declare -f install
    }

    while :; do
      printf '   Do you want to review the content? [Yes/No/Cancel] > ' >&2
      read -r answer >&2
      case $(printf '%s\n' "$answer" | tr '[:upper:]' '[:lower:]') in
        y|yes)
          case "$(command -v bat)${VISUAL:-${EDITOR}}" in
            *bat*)
              self | LESS='' bat --paging always --file-name install.sh
              ;;
            *vim*) # o vim, o nvim, o neovim ... e sua parentela compatível
              self | ${VISUAL:-${EDITOR}} -c ':set syntax=tmux' -R -
              ;;
            *)
              tput smcup
              clear
              self | LESS='-R' ${PAGER:-less}
              tput rmcup
              ;;
          esac
          break
          ;;
        n|no)
          break
          ;;
        c|cancel)
          printf '\n'
          printf '⛔️ Installation aborted...\n' >&2 && exit 1
          ;;
      esac
    done
  ) < /dev/tty || exit 1
  printf '\n'
fi

# ───────────────────────────────────────────────────────────────────────────────
# § V. DA CONSUMMAÇÃO — INVOCAÇÃO DO RITO
#
#   Postas e demonstradas todas as proposições que antecedem, invoque-se
#   emfim a funcção `install`, e que a obra inteira se cumpra.
# ───────────────────────────────────────────────────────────────────────────────
install
}
# ═══════════════════════════════════════════════════════════════════════════════
#
#   FIM DO RITO.
#
#   Assentado o compendio segundo os lemmas supra, dá-se por consummada
#   a installação. Se algum desconcerto restar, attribua-se á machina ou
#   á mão do copista, e jámais ao methodo, que é infallivel.
#
#   Dado no gabinete do auctor, sob a luz do candieiro a gaz, findo o
#   derradeiro lemma.
#
#                                             Quod Erat Demonstrandum.
# ═══════════════════════════════════════════════════════════════════════════════
