From: Steven Haigh <netwiz@crc.id.au>
Subject: Software RAID5 write issues
Date: Thu, 11 Jun 2009 03:17:19 +1000
Message-ID: <AB9F712C-7A3F-4832-B60B-AB56DE448F14@crc.id.au>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

After a week and a bit of googling, experimenting and frustration I'm  
posting here and hoping I can get some clues on what could be wrong  
with my 5 disk RAID5 SATA array.

The array in question is:
md1 : active raid5 sdg1[0] sdf1[1] sde1[3] sdd1[2] sdc1[4]
       1172131840 blocks level 5, 1024k chunk, algorithm 2 [5/5] [UUUUU]

All 5 drives are connection to a sil_sata controller (a 3112 & a 3114)  
set up as a simple SATA controller (ie no RAID here).

Once the system buffer is full, write speeds to the array are usually  
under 20MB/sec.

I am currently running CentOS 5.3 (kernel  
2.6.18-128.1.10.el5.centos.plus).

I have lodged a bug report against RHEL 5.3, as I believe something is  
not quite right here, but haven't been able to narrow down the exact  
issue.
	https://bugzilla.redhat.com/show_bug.cgi?id=502499

Using bonnie++ to benchmark the array, it shows sequential block reads  
at 90MB/sec but writes at 11MB/sec across the RAID5 array - a  
difference I really didn't expect.

Any pointers on how to try to tackle this one and figure out the root  
cause of the problem would be VERY helpful!

--
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897



