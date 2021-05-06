int calculateMedian(List nums) {
  //clone list
  List clonedNums = nums;
  clonedNums.addAll(nums);

  //sort list
  clonedNums.sort((a, b) => a.compareTo(b));

  int median;

  int middle = clonedNums.length ~/ 2;
  if (clonedNums.length % 2 == 1) {
    median = int.parse(clonedNums[middle]);
  } else {
    median = ((clonedNums[middle - 1] + clonedNums[middle]) / 2.0).round();
  }

  return median;
}
