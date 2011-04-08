From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Fri, 08 Apr 2011 16:58:49 +0200
Message-ID: <4D9F22A9.1030005@web.de>
References: <4D9EC097.7010600@web.de> <20110408151751.5e2b61f1@natsu> <4D9F1962.3050806@web.de> <4D9F1A5A.1060600@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9F1A5A.1060600@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Subject: Re: RAID6 simply does not start as /dev/md8
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-08 16:36 (+0200)

> Do you have perhaps old raid metadata on the disks? Are you certain you
> have no raid metadata on the whole disks?
> you can check with mdadm --Examine /dev/sdc
> 
> Cheers
> 
> 
> Rudy
> 

To eliminate this possibility, I "zeroed" all six disks before I created
the array:
dd if=/dev/zero of=/dev/sda bs=1M
...
dd if=/dev/zero of=/dev/sdf bs=1M

Output of mdadm -E /dev/sda1:
	/dev/sda1:
        	  Magic : a92b4efc
	        Version : 1.2
	    Feature Map : 0x0
	     Array UUID : 6286b922:2da22a6c:f8fba333:fc88f457
        	   Name : Atlas:8  (local to host Atlas)
	  Creation Time : Fri Apr  8 00:58:12 2011
	     Raid Level : raid6
	   Raid Devices : 6

	 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
	     Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
	  Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
	    Data Offset : 2048 sectors
	   Super Offset : 8 sectors
        	  State : clean
	    Device UUID : 1a016923:a408d8ee:d8f6625f:bcf55b66

	    Update Time : Fri Apr  8 09:53:13 2011
	       Checksum : 69969b9b - correct
        	 Events : 19

	         Layout : left-symmetric
	     Chunk Size : 512K

	   Device Role : Active device 0
	   Array State : AAAAAA ('A' == active, '.' == missing)

The complete output of mdadm -E /dev/sd[a,b,c,d,e,f]1 can be found here:
http://nopaste.info/658b72791c_nl.html

Best regards,
Yann
