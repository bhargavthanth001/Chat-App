// Online Java Compiler
// Use this editor to write, compile and run your Java code online

class HelloWorld {
    public static void main(String[] args) {
        int rows = 6;  
        int cols = 4;
        
        int[][] points = {
            {1, 5}, 
            {2, 4}, {2, 5}, 
            {3, 1}, 
            {4, 1}, {4, 2},
        };
        
        for(int i = 0; i < 6; i++){
            for(int j = 0; j < 6; j++){
                if(i == 0  || i == 5){
                    System.out.print("*****");
                }else if(j == 0  || j == 5){
                    System.out.print("*");
                }else{
                    for(int k = 0; k < 7; k++){
                        System.out.print(" ");
                    }
                }

            }
            System.out.println();
        }
    
    }
    private static boolean isPoint(int i,int j, int[][] positions){
        for (int[] position : positions) {
            if (position[0] == i && position[1] == j) {
                return true;
            }
        }
        return false;
    }
}
