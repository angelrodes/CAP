# CAP
Cosmo-Ages Plotter (CAP). Just plot age groups in BGF order.

Angel Rodes, 2020


## Averages

Blue boxes depict the Best Gaussan Fits (BGF). See https://angelrodes.wordpress.com/2020/12/07/cosmogenic-exposure-age-averages/

## Input

The input file is called `data.csv`. It has to include:

* One header line: ` Sample name , age , uncertainty , moraine name `
* Four columns of data

`data.csv` example data from [Pallàs *et al.* (2006)](https://doi.org/10.1016/j.quascirev.2006.04.004)

## Output

BGF averages are printed in the command window:

```
>> CAP
BGF:
Llastres de Besiberri:9.4229 +/- 0.65021
Mulleres:10.4536 +/- 0.37976
Pleta Naua:10.1124 +/- 1.4822
Santet:13.8811 +/- 2.2521
```

Graphical output:

![Screenshot at 2022-01-24 17-14-13](https://user-images.githubusercontent.com/53089531/150821190-6340fbf2-9b92-4794-b1c6-96c5e244fa30.png)

---

Happy plotting!
