#include <unistd.h>

int
main(void)
{
    int s1 = add_two_integers(3, 5);
    int s2 = add_two_integers(-5, 4);

    print_int("s1=", s1);
    print_int("s2=", s2);

    return 0;
}
