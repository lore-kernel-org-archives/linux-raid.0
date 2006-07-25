From: marco <thedrop@infinito.it>
Subject: write back cache and barrier questions
Date: Tue, 25 Jul 2006 15:41:05 +0000 (UTC)
Message-ID: <loom.20060725T173745-751@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I don't have a deep knowledge about filesystems and I've few experiences with 
raid configuration, so I need someone who can answear some questions about 
write back cache and barriers.

I have two sata hd (sda, sdb) configured in bios-raid 0 and relative device 
created by dmraid on boot (nvidia_ihfaaicb).

(1) what should I do to know if the write back cache is enabled or not ?
(2) if the write cache is enabled on both sda and sdb this mean that is enabled 
also on the raid device (/dev/mapper/nvidia_ihfaaicb) ?
(3) how should I do to enable/disable the write cache on the raid device ?

If I try mounting a xfs filesystem I get a message like "barriers are not 
supported by this device" but if I mount a ext3 or a reiserfs filesystem 
respectively with options barrier=1 and barrier=flush they don't complain.
If I mount the reiserfs I explicity get a message like "using barriers".
So who tells the truth ?? 

(4) is there a way to know if the raid device supports barrier or not ?
(5) is there a (not dangerous) test I can do to figure out if barriers are 
really enabled and used with ext3 and reiserfs filesystems ?

Thanks for reading the message
Marco


