#include "stdio.h"
#include "string.h"

/* Given a string aStr, computes an array Z of the string similarity
 * (length longest common prefix) of each suffix of aStr. Returns the sum of Z.
 * */
int suffix_sims(const char* aStr, int aLen) {
    int sim_sum = aLen;
    int Z[100000];
    for(int ii=0;ii<100000;ii++) {
        Z[ii] = 0;
    }
    int l = 0;
    int r = 0;
    for(int k=1; k<aLen;k++) {
        if (k <= r) {
            int pos = k-l; //position in window
            int b = r - k + 1; //distance from k to the end of the window
            if (Z[pos] < b) {
                Z[k] = Z[pos];
            } else {
                int i=b;
                for(; i<aLen;i++) {
                    if (! ( (k+i < aLen) && (aStr[i] == aStr[k+i]) ) ) {
                        break;
                    }
                }
                Z[k] = i;
                r = i + k -1;
                l = k;
            }
        } else {
            int j=k;
            int i=0;
            while (aStr[j] == aStr[i]) {
                i++;
                j++;
            }
            l = k;
            r = j -1;
            Z[k] = i;
        }
    }
    for(int i=0; i<aLen; i++) {
        sim_sum += Z[i];
    }
    return sim_sum;
}

int main(int argc, char** argv) {
    int num_lines;
    char rest[5];
    scanf("%d", &num_lines);
    gets(rest);
    char c[100000];
    for(int i=0; i<num_lines; i++) {
        gets(c);
        printf("%i\n",suffix_sims(c, strlen(c)));
    }
    return 0;
}
