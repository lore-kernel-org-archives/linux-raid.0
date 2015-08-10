From: Tarak <tarak.a@samsung.com>
Subject: Problem with XOR Engine
Date: Mon, 10 Aug 2015 23:53:03 +0000 (UTC)
Message-ID: <loom.20150811T015114-194@post.gmane.org>
References: <29343933.117831364361439771.JavaMail.weblogic@epml26> <3054921.TrJcO0kqP2@xrated> <4243BB9A-D764-40FF-BD33-611F72C4C0E5@bingner.com>
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

Thanks and Regards
Tarak



