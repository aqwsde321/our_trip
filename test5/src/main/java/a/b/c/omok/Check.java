package a.b.c.omok;

public class Check{
    static int SIZE = PlayController.SIZE-1;
	static int count;
    static int _r;
    static int _c;
	
	public static boolean check(boolean[][] a, int r, int c) {
		//마지막에 둔 돌 기준으로 ㅡ, |,  \, / 체크함
		//   행 ㅡ 체크            열 | 체크            대각선 \ 체크          대각선 / 체크
		if(rowCheck(a,r,c) || colCheck(a,r,c) || dia1Check(a,r,c) || dia2check(a,r,c)) {
			return true;
		}else return false;
	}
	
	// 대각선 / 체크     ↗ 방향 체크,  ↙ 방향 체크
	private static boolean dia2check(boolean[][] a, int r, int c) {
		_r = r;		// 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		_c = c;		// 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		count = 1;  // 출발점(마지막에 둔 돌) 1개 부터 돌 카운트
		
		//  ↙ 방향 체크
		while(c>0 && r<SIZE && a[++r][--c]) {
			count++;
		}
		
		//  ↗ 방향 체크
		while(_c<SIZE && _r>0 && a[--_r][++_c] ) {
			count++;
		}
		
		if(count >= 5) return true;
		else return false;
		
	}
	
	// 대각선 \ 체크     ↖ 방향 ↘ 방향 체크
	private static boolean dia1Check(boolean[][] a, int r, int c) {
		_r = r;		// 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		_c = c;		// 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		count = 1; // 출발점(마지막에 둔 돌) 1개 부터 돌 카운트
		
		//  ↖ 방향 체크
		while(c>0 && r>0 && a[--r][--c]) {
			count++;
		}
		
		//  ↘ 방향 체크
		while(_c<SIZE && _r<SIZE && a[++_r][++_c] ) {
			count++;
		}
		
		if(count >= 5) return true;
		else return false;
		 
	}
	
	// 열 | 체크    ↑ ↓ 방향 체크
	private static boolean colCheck(boolean[][] a, int r, int c) {
		_r = r; // 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		count = 1; // 출발점(마지막에 둔 돌) 1개 부터 돌 카운트
		
		//  ↑ 방향 체크
		while(r>0 && a[--r][c]) { 
			count++;
		}
		
		// ↓ 방향 체크
		while(_r<SIZE && a[++_r][c] ) {
			count++;
		}
		
		if(count >= 5) return true;
		else return false;
	}
	
	// 행 ㅡ 체크    ← 방향 한번,  → 방향 한번 체크
	private static boolean rowCheck(boolean[][] a, int r, int c) {
		_c = c;		// 출발점(마지막에 둔 돌 위치) 복사해서 기억하기
		count = 1; // 출발점(마지막에 둔 돌) 1개 부터 돌 카운트
		
		//   ←  방향 체크
		while(c>0 && a[r][--c]) {
			count++;
		}
		
		//  → 방향 체크
		while(_c<SIZE && a[r][++_c] ) {
			count++;
		}
		
		if(count >= 5) return true;
		else return false;
		
	}
	
	
}