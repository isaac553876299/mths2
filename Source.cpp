#include <iostream>
#include <string>

void plusequal(std::string& a, std::string& b)
{
	for (const auto& i : a) if (i < '0' || i > '9') return;
	for (const auto& i : b) if (i < '0' || i > '9') return;

	std::cout << a << " += " << b << " = ";

	while (a.length() < b.length()) a.insert(0, "0");
	while (b.length() < a.length()) b.insert(0, "0");

	size_t n = a.length();
	unsigned char r;
	unsigned char bring = 0;
	for (int i = n - 1; i >= 0; --i)
	{
		r = a[i] + b[i] - 2 * '0' + bring;
		bring = 0;
		if (r > 9)
		{
			r -= 10;
			bring = 1;
		}
		a[i] = r + '0';
	}
	if (bring > 0)
	{
		const char c = bring + '0';
		a.insert(0, 1, c);
	}

	std::cout << a << std::endl;
}

int main()
{
	std::string x = "4294967295";
	std::string y = "4294967295";
	plusequal(x, y);
	return 0;
}