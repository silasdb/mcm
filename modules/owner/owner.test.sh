test -e "$path" || exit 1
case "$(uname)" in
Linux) o="$(stat -c %U "$path")" ;;
*) o="$(stat -f %Su "$path")" ;;
esac
test x"$o" = x"$owner"
