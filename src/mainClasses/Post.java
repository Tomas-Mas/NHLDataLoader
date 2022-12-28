package mainClasses;

import java.util.ArrayList;

public class Post {

	private String post_id;

    private int actor_id;

    private String picOfPersonWhoPosted;
    //private String nameOfPersonWhoPosted;
    private String message;
    //private String likesCount;
    private ArrayList<String> comments;
    private String timeOfPost;
    
    public void print() {
    	System.out.println("post_id: " + post_id);
    	System.out.println("actorId: " + actor_id);
    	System.out.println("picOfPersonWhoPosted: " + picOfPersonWhoPosted);
    	//System.out.println("nameOfPersonWhoPosted: " + nameOfPersonWhoPosted);
    	System.out.println("message: " + message);
    	//System.out.println("likesCount: " + likesCount);
    	for(String s: comments) {
    		System.out.println("comment: " + s);
    	}
    	System.out.println("timeOfPost: " + timeOfPost);
    	
    }
}
