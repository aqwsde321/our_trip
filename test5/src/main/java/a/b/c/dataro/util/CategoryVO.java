package a.b.c.dataro.util;

import lombok.Data;

@Data
public class CategoryVO { 
	private int region_no;
	private int hashtag_no;
	private int[] hashtag_no_arr;
	private String board_name;
	private int board_no;
	
	private String hashtag_name;
	private String region_name;
	private int[] region_no_arr;
}
