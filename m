From: Randall Smith <randall@tnr.cc>
Subject: resync hangs
Date: Sat, 06 Jun 2009 12:42:35 -0500
Message-ID: <h0e9qm$91r$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On occasions that my raid5 array needs to resync (power outage, etc), 
the resync stops progressing early on.  This is on Debian Lenny.  I've 
tried the stock 2.6.26 kernel as well as the 2.6.29 kernel from Sid.

On boot:

[   10.022020] md: md2: raid array is not clean -- starting background 
reconstruction
[   10.032896] raid5: allocated 3226kB for md2
[   10.032936] raid5: raid level 5 set md2 active with 3 out of 3 
devices, algorithm 2
[   10.033685]  md2: unknown partition table
[   20.492246] md: resync of RAID array md2


~$ cat /proc/mdstat

md2 : active raid5 sda3[0] sdf3[2] sdc3[1]
       488279424 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
       [>....................]  resync =  0.0% (128/244139712) 
finish=1220697.9min speed=0K/sec


I it resyncs find when using a live cd.  Any ideas what's causing it to 
hang.

--Randall


