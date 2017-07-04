# The ONE Assignment
Results for the VANET scenario can be found in ```./final_comparison``` and ```./final_long_comparison```.

The configuration files that generate such results are stored in the two sub-folders of ```./new_test_settings```.

In order to run all of the shorter tests, one would run:

```for i in $(find new_test_settings/final_settings/ -type f); do ./one.sh -b 30 $i; done```
