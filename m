From: Don Jessup <donj@asaca.com>
Subject: Raid5 Poor Permformance
Date: Thu, 16 Oct 2003 10:48:12 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031016174812.68849.qmail@web14512.mail.yahoo.com>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


  I have been looking at the performance of the RAID5 read
  on the following kernels
                                MB/sec READ on 5 + 1 RAID5
   2.4.9-e.27  SMP  RedHat      30
   2.4.9-ac18  SMP              28
   2.4.22      SMP              80

    As numbers indicate there is a large difference in performance.

   I wonder if anybody else had seen this problem during the 2.4.9
   kernel and what the fix was?

  I would use the 2.4.22 but it has a more serious issue with hanging
   when doing a scsi hot add/remove .   The 2.4.9-e.27 does not
   have this scsi hang issue.  




=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
