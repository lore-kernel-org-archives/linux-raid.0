From: Tarak Anumolu <tarak.a@samsung.com>
Subject: Re: Need some information about mdadm 3.2.5
Date: Tue, 11 Aug 2015 05:51:29 +0000 (UTC)
Message-ID: <loom.20150811T075020-468@post.gmane.org>
References: <29343933.117831364361439771.JavaMail.weblogic@epml26>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi
 
My name is Tarak.

I got some problem with the XOR engine while creating the RAID array.

The parity data is getting corrupted and my system is not able to recognize 
it and some how we are getting the hard disk error.

I found the above issue is happening when I  enable  
CONFIG_RAID_ZERO_COPY=y in my Linux configuration.


Without this option everything is working fine.

Following are the version details

Linux : 3.0.34

GCC : 4.6.2 (GCC) ) 
mdadm : v3.2.5 


I want to know the way to fix the RAID parity error.

Please help me on this.


Thanks & Regards

Tarak Ramgopal Anumolu 

Security Solution Division

SAMSUNG TECHWIN CO.,LTD

Phone : +82-70-7147-8396

Mobile: +82-10-7249-8396

E-mail : tarak.a@samsung.com


