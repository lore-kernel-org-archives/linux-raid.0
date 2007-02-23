From: Tomka Gergely <gergely@tomka.hu>
Subject: beginner error detection
Date: Fri, 23 Feb 2007 13:11:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0702231301180.3550@tomka.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have a simple sw raid1, over two sata disks. One of the disks started to 
complain (s.m.a.r.t. errors). I think in the near future i witness a disk 
failure. But i don't know how this thing is happening with raid1, so i 
have some questions. If these questions answered somewhere (faq, manpage, 
url), then feel free to redirect me to this source(s). 

Can the raid1 detect and handle disk errors? If one block goes wrong, how 
can the raid1 driver choose which was the correct, original value?

Sata systems can die gracefully? When in a good scsi system happens a 
total disk failure, then the scsi makes the disk fail, mdadm removes 
the disk from the array, and in the morning i see a nice e-mail. When a 
PATA disk dies, the system goes down, so i need to call a cab. I dont know 
how the sata behaves in this situation.

The kernel 2.6.20 (with skas patch), the controller :
nVidia Corporation CK804 Serial ATA Controller (rev f3)

Thanks.

-- 
Tomka Gergely, gergely@tomka.hu
