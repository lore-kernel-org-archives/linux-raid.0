From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: MD Warnings on RAID5 linux 2.4.22
Date: Fri, 26 Mar 2004 18:38:53 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403262338.i2QNcvW29494@dns1.watkins-home.com>
References: <20040326232438.98003.qmail@web14526.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040326232438.98003.qmail@web14526.mail.yahoo.com>
To: donj@asaca.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Are they on the same disk?
I guess you added the "True".
If 1 disk fails your RAID array will see 2 failures.
You will lose data if this happens!

This trick is to only use each disk once for any one array.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Don Jessup
Sent: Friday, March 26, 2004 6:25 PM
To: linux-raid@vger.kernel.org
Subject: MD Warnings on RAID5 linux 2.4.22



  I have raid 5 array that I'm --assembling on a computer but when I
 assemble it and start and stop the array.  I get the following warnings.



Apr  5 15:19:57 DM200_791498 kernel: md14: WARNING: [dev e7:a4] appears to
be
on the same physical disk as [dev
e7:a0]. True
Apr  5 15:19:57 DM200_791498 kernel:      protection against single-disk
failure might be compromised.
Apr  5 15:19:57 DM200_791498 kernel: md: bind<[dev e7:a4],5>
Apr  5 15:19:58 DM200_791498 kernel:  [events: 0000007f]
Apr  5 15:19:58 DM200_791498 kernel: md14: WARNING: [dev e7:90] appears to
be
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


