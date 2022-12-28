package mainClasses;

import java.util.ArrayList;

public class MyModel {
	
	private PageInfo pageInfo;
    private ArrayList<Post> posts = new ArrayList<>();
    
    public void print() {
    	this.pageInfo.print();
    	System.out.println("\n");
    	for(Post p: posts) {
    		p.print();
    		System.out.println("\n\n");
    	}
    }
}
