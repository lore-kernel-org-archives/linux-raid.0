From: fixitdad5@verizon.net
Subject: RAID problem
Date: Wed, 14 Aug 2013 15:49:37 -0500 (CDT)
Message-ID: <1869496.205994.1376513377257.JavaMail.root@vznit170146>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you are still offering help with raid corruption due to the bug in kernels 3.2 and 3.3, I would like some help.

I load Ubuntu 12.04 precise (with kernel 3.2 since it was in the package) just 2 weeks ago. I had pre-existing raids and the raid's meta data was corrupted on the first boot after the successful installation so I have lost my data. I tried most of the suggestions that I found on the web, employing the intelligence in mdadm -assemble, etc. without success.

I have now updated the kernel to 3.4.0 rc7 (3.4.0-030400-generic #201205210521 SMP) and built an empty raid. However, I cannot boot without disconnecting the RAID drives. With the RAID drives hooked up and the updated kernel with the additional parameters listed below, I I fall into busybox and cannot boot successfully. What do I do now?
 
My configuration is 
Intel(R) Core(TM) i5 CPU 750 @ 2.67GHz
7983 MiB
running SELinux
Raid is a simple stripping (level 0) for speed
I have set the noautodetect and nodmraid parameters for the kernel
