#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#elif        //Unix
#define DLLEXPORT
#endif

#include <iostream>
#include <algorithm>
#include <string>

class Test
{
public:
    int add(int a, int b)
    {
        std::cout << "a: " << a << ", b: " << b << std::endl; 
        return a + b; 
    };
    float multiply(int a, float b)
    {
        std::cout << "a: " << a << ", b: " << b << std::endl; 
        return a * b;
    };
    double divide(float a, float b)
    {
        std::cout << "a: " << a << ", b: " << b << std::endl; 
        return a / b;
    };

    char* returnCharPtr(double num)
    {
        std::cout << num << std::endl;
        std::string s = "The number is ";
        s += std::to_string(num);
        return strdup(s.data());
    };

    float takeCharPtr(char* inp)
    {
        std::cout << inp << std::endl;
        return float(strlen(inp));
    }

    char* takeAndReturnCharPtr(char* inp, float num)
    {
        std::string s = inp;
        s += std::to_string(num);
        return strdup(s.data());
    }
};

extern "C"
{
    DLLEXPORT Test* Test_new() { return new Test(); };
    DLLEXPORT int Test_add(Test* test, int a, int b) { return test->add(a, b); };
    DLLEXPORT float Test_multiply(Test* test, int a, float b) { return test->multiply(a, b); };
    DLLEXPORT double Test_divide(Test* test, float a, float b) { return test->divide(a, b); };
    DLLEXPORT char* Test_returnCharPtr(Test* test, double num) { return test->returnCharPtr(num); };
    DLLEXPORT float Test_takeCharPtr(Test* test, char* inp) { return test->takeCharPtr(inp); };
    DLLEXPORT char* Test_takeAndReturnCharPtr(Test* test, char* inp, float num) { return test->takeAndReturnCharPtr(inp, num); };
}