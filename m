From: Don Jessup <donj@asaca.com>
Subject: MD Warnings on RAID5 linux 2.4.22
Date: Fri, 26 Mar 2004 15:24:38 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040326232438.98003.qmail@web14526.mail.yahoo.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



  I have raid 5 array that I'm --assembling on a computer but when I
 assemble it and start and stop the array.  I get the following warnings.



Apr  5 15:19:57 DM200_791498 kernel: md14: WARNING: [dev e7:a4] appears to be
on the same physical disk as [dev
e7:a0]. True
Apr  5 15:19:57 DM200_791498 kernel:      protection against single-disk
failure might be compromised.
Apr  5 15:19:57 DM200_791498 kernel: md: bind<[dev e7:a4],5>
Apr  5 15:19:58 DM200_791498 kernel:  [events: 0000007f]
Apr  5 15:19:58 DM200_791498 kernel: md14: WARNING: [dev e7:90] appears to be
on the same physical disk as [dev
e7:a4]. True
Apr  5 15:19:58 DM200_791498 kernel:      protection against single-disk
failure might be compromised.
Apr  5 15:19:58 DM200_791498 kernel: md: bind<[dev e7:90],6>




   I was wondering how to make these warnings stop?  There does not 
  seem to be a problem with single disk failure.

   The command I'm using to assemble the RAID looks like the following:
      mdadm --assemble /dev/md14
--uuid=c9cc5194:50e0de0d:af3b7236:a60790c9
--update=super-minor /dev/mapd145:1 /dev/mapd149:1 /dev/mapd153:1
/dev/mapd157:1 /dev/mapd161:1 /dev/mapd165:1


=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
