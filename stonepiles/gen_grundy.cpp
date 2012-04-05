#include <vector>
#include <iostream>
#include <algorithm>

/* This class generates the sprague-grundy numbers of the stone-pile game
 * defined in the interviewstreet problem. See:
 * http://www.gabrielnivasch.org/fun/combinatorial-games/sprague-grundy
 * to understand the underlying algorithm.
 * The Grundy class defines an object that returns grundy numbers, including
 * memoization of those numbers.
 * 'P' (BOB) wins if the grundy number is 0, and 'N' (ALICE) wins otherwise.
 */
class Grundy {
    std::vector<int> grundy_memo;
    int size;
public:
    Grundy(int aSize): size(aSize), grundy_memo(aSize,-1){}
    Grundy(int aSize, int aGValues[], int values_size):
        size(aSize),
        grundy_memo(aSize) {
        for(std::size_t i=0; i<aSize; ++i) {
            if (i<values_size) {
                grundy_memo[i] = aGValues[i];
            } else {
                grundy_memo[i] = -1;
            }
        }
    }
    
    int grundy(int n) {
        if (grundy_memo[n] != -1) {
            return grundy_memo[n];
        }
        if (n<3) {
            grundy_memo[n] = 0;
            return 0;
        }
        std::vector<int> decomposition;
        std::vector<int> g_values;
        grundy_helper(n,decomposition,g_values);

        //the grundy of n is the mex of g_values
        sort(g_values.begin(), g_values.end());
        int mex = 0;
        for (int i = 0; i<g_values.size(); ++i) {
            if (g_values[i] == mex) {
                ++ mex;
            }
        }
        grundy_memo[n] = mex;
        return mex;
    }

    int grundy(std::vector<int>& a) {
        int val = grundy(a[0]);
        for(int i=1; i<a.size(); ++i) {
            val ^= grundy(a[i]);
        }
        return val;
    }

    int grundy(int a[], int size) {
        std::vector<int> vec(size);
        for(std::size_t i=0; i<size; ++i) {
            vec[i] = a[i];
        }
        return grundy(vec);
    }

    //recursively compute all the possible decompositions of n, and
    //get the grundy number of all those.
    //used stores the decomposition so far
    //g_values accumulates the grundy function value of each partition
    void grundy_helper(int n, std::vector<int>& used, std::vector<int>& g_values) {
        for(int i=1; i<=(n-1)/2; ++i) {
            int n_new = n-i;
            bool i_in_decomp = false;
            bool n_in_decomp = false;
            for(int j=0; j<used.size(); ++j) {
                if (used[j] == i) {
                    i_in_decomp = true;
                }
                if (used[j] == n_new) {
                    n_in_decomp = true;
                }
            }
            if (!i_in_decomp) {
                used.push_back(i);
                if (!n_in_decomp) {
                    used.push_back(n_new);
                    g_values.push_back(grundy(used));
                    used.pop_back();
                }
                grundy_helper(n_new, used, g_values);
                used.pop_back();
            }
        }
    }
};

int main(int argc, char** argv) {
    int size;
    std::cin >> size;
    Grundy g(size+1);
    std::cout << "{";
    for(int i=1; i<=50; ++i) {    
        std::cout << g.grundy(i) << ",";
    }
    std::cout << "}" << std::endl;
    return 0;
}
