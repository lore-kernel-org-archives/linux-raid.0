From: Bill Davidsen <davidsen@tmr.com>
Subject: Expandable raid
Date: Sat, 13 Sep 2008 11:29:04 -0400
Message-ID: <48CBDC40.1010505@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am setting up a system with five drives. Initially two will be for the 
system and three for other uses. In about 4-6 weeks the three will be 
added to the original two. Thoughts on picking a raid config to make 
this easy? I would like to use raid-10, but I don't see a way to grow it.

Kernel will be initially FC9 (whatever is shipping in the next few 
days), but a kernel.org 2.6.27 will be going in shortly in hopes that 
the changes to MTRR handling will allow a PAE kernel to use all of 8GB 
memory in 32 bit mode.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


