From: Mike Viau <viaum@sheridanc.on.ca>
Subject: Impact of missing parameter during mdadm create
Date: Mon, 28 Feb 2011 22:19:58 -0500
Message-ID: <BAY148-w3BBDF9F7CC665C5870D23EFC10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello mdadm hackers,

I was wondering what (if any) impact would creating an array with the missing parameter have on subsequent assemblies of a mdadm array? 

When the array was created, I used a command like:

mdadm --create -l5 -n3 /dev/md0 /dev/sda1 missing /dev/sdb1

And then loaded some initial data on the md0 array from /dev/sdd1, and then I zeroed out /dev/sdd1 and added it to the md0 array.

Details on each drive seem to show they all belong to the same Array UUID, but when the array is (re)assembled (on boot or manually), only /dev/sd{a,b}1 are added to mdadm array automatically, and /dev/sdd1 must be re-added manually.


> mdadm --examine /dev/sd{a,b,d}1
> /dev/sda1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x0
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
> 
> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> State : clean
> Device UUID : 25f4baf0:9a378d2c:16a87f0c:ff89b2c8
> 
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : 37383bee - correct
> Events : 32184
> 
> Layout : left-symmetric
> Chunk Size : 512K
> 
> Device Role : Active device 0
> Array State : AAA ('A' == active, '.' == missing)
> /dev/sdb1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x0
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
> 
> Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> State : clean
> Device UUID : f20ab5fd:1f141cae:e0547278:d6cf063e
> 
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : a70821e2 - correct
> Events : 32184
> 
> Layout : left-symmetric
> Chunk Size : 512K
> 
> Device Role : Active device 1
> Array State : AAA ('A' == active, '.' == missing)
> /dev/sdd1:
> Magic : a92b4efc
> Version : 1.2
> Feature Map : 0x2
> Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
> Name : XEN-HOST:0 (local to host XEN-HOST)
> Creation Time : Mon Dec 20 09:48:07 2010
> Raid Level : raid5
> Raid Devices : 3
> 
> Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
> Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
> Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
> Data Offset : 2048 sectors
> Super Offset : 8 sectors
> Recovery Offset : 610474280 sectors
> State : clean
> Device UUID : 33d70114:ffdc4fcc:2c8d65ba:ab50bab2
> 
> Update Time : Fri Feb 18 16:32:19 2011
> Checksum : b692957e - correct
> Events : 32184
> 
> Layout : left-symmetric
> Chunk Size : 512K
> 
> Device Role : Active device 2
> Array State : AAA ('A' == active, '.' == missing)






-M


 		 	   		  