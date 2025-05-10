#include <iostream>

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        std::cerr << "Usage: " << argv[0] << " <bucket_name>" << " <thing_name>" << std::endl;
        return 1;
    }

    const Aws::String bucket_name = argv[1];
    const Aws::String thing_name = argv[2];
    const Aws::String aws_region = argv[2];

    return 0;
}
