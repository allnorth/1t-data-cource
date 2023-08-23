import scala.compiletime.ops.int
@main def Main: Unit = {
  val r = "Hello, Scala!"
  println(r)

  //выводит фразу «Hello, Scala!» справа налево
  println(r.reverse)

  //переводит всю фразу в нижний регистр
  println(r.toLowerCase())

  //удаляет символ!
  println(r.dropRight(1))

  //добавляет в конец фразы «and goodbye python!»
  println(r + " and goodbye python!")

  //Напишите программу, которая вычисляет ежемесячный оклад сотрудника после вычета налогов. На вход вашей программе подается
  //значение годового дохода до вычета налогов, размер премии  — в процентах от годового дохода и компенсация питания. 
  def get_income(year_inc: Int, reward: Int, compensation: Int): Int = {
    val year_inc_net = year_inc - (year_inc * 0.13)
    val revard_amt = (year_inc_net / 100) * reward
    return ((year_inc_net + revard_amt + compensation) / 12).toInt
  }
  println(get_income(1000000, 20, 10000))

  //Напишите программу, которая рассчитывает для каждого сотрудника отклонение (в процентах) от среднего значения оклада
  //на уровне всего отдела. В итоговом значении должно учитываться в большую или меньшую сторону отклонение размера оклада.
  //На вход вашей программе подаются все значения, аналогичные предыдущей программе, а также список со значениями окладов
  //сотрудников отдела 100, 150, 200, 80, 120, 75.
  def deviation(year_inc: Int, reward: Int, compensation: Int, lst: List[Int]): Double = {
    val income = get_income(year_inc, reward, compensation)
    return (income / (lst.sum / lst.length) * 100 - 100).abs
  }
  val lst1 = List(100, 150, 200, 80, 120, 75)
  println(deviation(100, 20, 10, lst1))

  //Попробуйте рассчитать новую зарплату сотрудника, добавив (или отняв, если сотрудник плохо себя вел) необходимую сумму
  //с учетом результатов прошлого задания. Добавьте его зарплату в список и вычислите значение самой высокой зарплаты и самой низкой.
  val new_sal = get_income(50000, 10, 20)
  val lst2 = lst1.::(new_sal)

  println("Значение самой высокой зарплаты: " + lst2.head)
  println("Значение самой низкой зарплаты: " + lst2.last)

  //Также в вашу команду пришли два специалиста с окладами 350 и 90 тысяч рублей.
  //Попробуйте отсортировать список сотрудников по уровню оклада от меньшего к большему. 
  val lst3 = lst2 ::: List(350, 90)
  val sorter_lst = lst3.sorted
  println(sorter_lst)

  //Кажется, вы взяли в вашу команду еще одного сотрудника и предложили ему оклад 130 тысяч.
  //Вычислите самостоятельно номер сотрудника в списке так, чтобы сортировка не нарушилась, и добавьте его на это место.
  val new_sal2 = 130
  val id = sorter_lst.indexWhere(element => element > new_sal2)
  val lst4 = sorter_lst.take(id) ++ List(new_sal2) ++ sorter_lst.drop(id)
  println(lst4)

  //Попробуйте вывести номера сотрудников из полученного списка, которые попадают под категорию middle.
  //На входе программе подается «вилка» зарплаты специалистов уровня middle.
  def get_middle(my_lst: List[Int], min: Int, max: Int): List[Int] = {
    var res = List[Int]()
    var id: Int = 0
    for (l <- my_lst) {
      if (l >= min && l <= max) {
        id = my_lst.indexWhere(element => element == l)
        res = res.::(id)
      }
    }
    return res
  }

  println(get_middle(lst4, 100, 200))

  //Однако наступил кризис и ваши сотрудники требуют повысить зарплату.
  //Вам необходимо проиндексировать зарплату каждого сотрудника на уровень инфляции  — 7 %.
  var lst5 = List[Int]()
  for (l <- lst4) {
    lst5 = lst5.::((l + l*0.07).toInt)
  }

  println(lst5)
}