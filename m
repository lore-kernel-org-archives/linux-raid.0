From: Christian Diehl <christian.diehl@kmstudiosystems.com>
Subject: Re: 3ware bad write speed.
Date: 02 Apr 2003 09:20:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1049268010.670.2245.camel@hippokrates>
References: <004f01c2f0b3$f72478d0$df01010a@moon>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <004f01c2f0b3$f72478d0$df01010a@moon>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi * 

I am using several hardware raid systems based on 3Ware, Adaptec and 
AC&NC hardware. 

The Mainboard of the test machine is a Supermicro P4DMS-6GM with two
Xeon 2.4GHz Processors and 1 Gig of RAM. 

IDE (WD 120 Gig) disks are used in the AC&NC Jetstor III (14 disks) and
in the 3Ware (7 disks). The Adaptec Raids use SCSI (Seagate) Disks. 

All these systems show a remarkably bad performance (max. 80 MB/s write
and max. 70 MB/s read, exact figures (bonnie++,iostat) available). 

I am using kernel 2.4.20 without any patches (Highmem on / i2o off) 
and an ext3 filesystem. 
I have played around with different stride settings and block sizes as
well as chunk sizes on the raid and experienced minor differences within
the above limits. 

By setting 

echo 256 > /proc/sys/vm/max-readahead 
echo 128 > /proc/sys/vm/min-readahead 

I could convince the 3ware to read data with up to 114 MB/s. 

So basically I am experiencing the same bad speeds (especially write
speeds) as Donghui (and others). 

It seems to me like there might be a common reason behind the bad
performance. (the VM Layer settings?) 

While writing this email I just finished a bonnie++ run on a new
software raid using 8 SCSI Disks: 

softr.8disk.64chunk,2000M:64k,13630,99,41206,41,27280,27,15278,97,156480,62,329.8,12,16,1322,81,+++++,+++,29177,99,1510,99,+++++,+++,3981,98 

That's an amazing difference in reading speed to the hardware raids
(soft:156480;hard:70155). I will most probably not be able to convert
all my Raids to Software Raids, so I would like to reach a similar
performance with the Hardware Raid. 


Any ideas,comments,...? 


Christian
