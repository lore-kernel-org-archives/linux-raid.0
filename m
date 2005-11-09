From: "Spencer Tuttle" <rodeojones@fastmail.fm>
Subject: New raid5 took 5 days for initial build on spare drive
Date: Wed, 09 Nov 2005 15:57:10 -0700
Message-ID: <1131577030.27623.247169656@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, I just created my first ever raid 5 using software raid.

I am using a 2.6.14 kernel and the just newly supported MV88SX6041
Marvell SATA Controller. I received the following errors when the device
is initialized in the kernel

blk_queue_max_hw_segments: set to minimum 1

repeated a bunch of times.

And I wonder if this is why it is so slow, my /proc/mdstat shows the
following:
orion ~ # cat /proc/mdstat
Personalities : [raid5]
md_d0 : active raid5 sda1[0] sdd1[4] sdc1[2] sdb1[1]
      234444288 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
      [===================>.]  recovery = 98.9% (77292696/78148096)
      finish=102.9min speed=136K/sec

unused devices: <none>

As you can see it is almost finished, but it has been a little over 5
days, seems a little high, for 80GB drives, but then again this is my
first time using mdadm. 

Could someone let me know if this is normal or if I have something
really messed up.

Spencer

-- 
http://www.fastmail.fm - mmm... Fastmail...

