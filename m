From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 28 Oct 2007 22:59:01 -0700
Message-ID: <472576A5.3030603@amfes.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com>	 <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>	 <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>	 <471FA485.6010705@tmr.com>  <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193294406.10336.76.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> Anyway, I happen to *like* the idea of using full disk devices, but the
> reality is that the md subsystem doesn't have exclusive ownership of the
> disks at all times, and without that it really needs to stake a claim on
> the space instead of leaving things to chance IMO.
>   
I've been re-reading this post numerous times - trying to ignore the 
burgeoning flame war :) - and this last sentence finally clicked with me.

As I'm a novice Linux user - and not involved in development at all - 
bear with me if I'm stating something obvious.  And if I'm wrong - 
please be gentle!

1.  md devices are not "native" to the kernel - they are 
created/assembled/activated/whatever by a userspace program.
2.  Because md devices are "non-native" devices, and are composed of 
"native" devices, the kernel may try to use those components directly 
without going through md.
3.  Creating a partition table somehow (I'm still not clear how/why) 
reduces the chance the kernel will access the drive directly without md.

These concepts suddenly have me terrified over my data integrity.  Is 
the md system so delicate that BOOT sequence can corrupt it?  How is it 
more reliable AFTER the completed boot sequence?

Nothing in the documentation (that I read - granted I don't always read 
everything) stated that partitioning prior to md creation was necessary 
- in fact references were provided on how to use complete disks.  Is 
there an "official" position on, "To Partition, or Not To Partition"?  
Particularly for my application - dedicated Linux server, RAID-10 
configuration, identical drives.

And if partitioning is the answer - what do I need to do with my live 
dataset?  Drop one drive, partition, then add the partition as a new 
drive to the set - and repeat for each drive after the rebuild finishes?
-- 
Daniel
