package com.xx.vo;

/**
 * 地址vo
 * 
 * @author wujialing
 */
public class AddressVo {
	
	private String country ; //国家
	
	private String city ; //城市
	
	public AddressVo() {
		
	}
	
	
	public AddressVo(String country,String city) {
		this.country = country ;
		this.city = city ;
	}
	
	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}
	
}
