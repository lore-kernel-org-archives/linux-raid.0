From: Jeroen Baten <jbaten@i2rs.nl>
Subject: question regarding a raid-1 set
Date: Tue, 26 Aug 2003 16:37:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308261637.08588.jbaten@i2rs.nl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

A customer of mine has had a crash due to powerfailure. Now the second disc of 
2 raid-1 configs (md1 and md2) won't kick on. The /proc/mdstat says:

Personalities : [raid0] [raid1] 
read_ahead 1024 sectors
md0 : active raid0 sdb1[1] sda2[0]
      1092224 blocks 32k chunks
      
md1 : active raid1 sdb5[1] sda5[0]
      3148608 blocks [2/1] [U_]
      
md2 : active raid1 sdb6[1] sda6[0]
      31848704 blocks [2/1] [U_]
      
unused devices: <none>

when he types 'raidhotadd  /dev/md2   /dev/sdb6' it
generates: "dev/md2: can not hot-add disk: disk busy"

What should he do to get the second drive to sync again?

kind regards,

p.s. I am not subscribed to this list. Can you reply to my email address? 
Thanks.

-- 
  Jeroen Baten            | EMAIL :  JBATEN@I2RS.NL
 ____  _  __              | web   :  www.i2rs.nl
  |  )|_)(_               | tel   :  +31 (0)30 221 00 11
 _|_/_| \__)              | fax   :  +31 (0)30 220 31 91
  Kometenlaan 26, 3721 JT, Bilthoven, the Netherlands

