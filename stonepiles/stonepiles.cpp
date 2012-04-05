#include <iostream>
#include <vector>

/* This implementation uses Sprague-Grundy theory to compute the winner of
 * each position. The values of the sprague-grundy function for each single rock
 * has been precomputed (and are hard-coded) for speed; Given these numbers, the
 * Sprague-Grundy number of a position with multiple stone piles is just the XOR
 * of the numbers of each individual pile. Zero corresponds to Alice winning,
 * and non-zero means Bob wins. See:
 * http://www.gabrielnivasch.org/fun/combinatorial-games/sprague-grundy
 */
class GrundySolver {
public:
    static int grundy_numbers[];
    const char* grundy(std::vector<int>& a) {
        int val = grundy_numbers[a[0]];
        for(int i=1; i<a.size(); ++i) {
            val ^= grundy_numbers[a[i]];
        }
        return (val==0) ? "BOB" : "ALICE";
    }
};

int GrundySolver::grundy_numbers[] = {-1,0,0,1,0,2,3,4,0,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46};

int main(int argc, char** argv) {
    int n;
    GrundySolver g;
    std::cin >> n;
    for(int i=0; i<n; ++i) {
        int num_elts;
        std::cin >> num_elts;
        std::vector<int> elts;
        for (int j=0; j<num_elts; ++j) {
            int num;
            std::cin >> num;
            elts.push_back(num);
        }
        std::cout << g.grundy(elts) << std::endl;
    }
    return 0;
}
