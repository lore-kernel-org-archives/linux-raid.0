From: Nagilum <nagilum@nagilum.org>
Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Mon, 16 Feb 2009 18:31:40 +0100
Message-ID: <20090216183140.15250l3o3o2hk8w0@cakebox.home>
References: <20090212031009.23983.14496.stgit@notabene.brown>
 <20090212081148.GD9439@rap.rap.dk> <4993E82D.1020309@fairbairn-family.com>
 <20090212094604.GA11981@rap.rap.dk>
 <alpine.LRH.2.00.0902120003100.3470@taurus.cesta.com>
 <4995A5AE.8020301@tmr.com> <18840.64312.247580.780346@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18840.64312.247580.780346@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


----- Message from neilb@suse.de ---------
     Date: Mon, 16 Feb 2009 16:35:52 +1100
     From: Neil Brown <neilb@suse.de>
  Subject: Re: [PATCH 00/18] Assorted md patches headed for 2.6.30
       To: Bill Davidsen <davidsen@tmr.com>
       Cc: Julian Cowley <julian@lava.net>, Keld Jorn Simonsen  
<keld@dkuug.dk>, linux-raid@vger.kernel.org

>> Ob. plug for raid5E: the advantages of raid5E are two-fold. The most
>> obvious is that head motion is spread over N+2 drives (N being number of
>> data drives) which improves performance quite a bit in the common small
>> business case of 4-5 drive setups. It also puts some use on each drive,
>> so you don't suddenly start using a drive which may have been spun down
>> for a month, may have developed issues since SMART was last run, etc.
>>
>
> Are you thinking of raid5e, where all the spare space is at the end of
> the devices, or raid5ee where it is more evenly distributed?

raid5E I'd say.

> So raid5e is just a normal raid5 where you don't use all of the space.
> When a failure happens, you reshape to n-1 drives, thus absorbing the
> space.
>
> raid5ee is much like raid6, but you don't read or write the Q block.
> If you lose a drive, you rebuild it in the space were the Q block
> lives.
>
> So would you just use raid6 normally and transition to a contorted
> raid5 on device failure?  Or would you really want to leave those
> blocks fallow?

My understanding is that 5EE leaves those blocks empty. Doing real Q  
blocks would entail too much overhead but it reminds of an idea I had  
some time ago. I call it lazy-Raid6 ;)

Problem: You have enough disks to run RAID6 but you don't want to pay  
the performance penalty* of RAID6.
The solution in those cases is usually RAID5+hotspare but maybe we can  
do better.
We could also use the hotspare to store the RAID6 polynom but we have  
to calculate this (or more specifically read/write the stripe/block)  
only when the disks are idle. This of course means that the hotspare  
will have a number of invalid blocks after each write operation but  
the majority of blocks will be up-to-date. (use a bitmap to mark dirty  
blocks and "clean up" when the disks are idle)
The goal behind this is to have basically the same performance as with  
normal RAID5 but a higher failure resilience. In my experience  
harddisks often fail partially so that if you have a partial and a  
complete disk failure, chances are you will be able to recover. Even  
when two disks fail completely the number of dirty blocks should  
usually be pretty low so we would be able recover most of the data.
If there is a single disk failure we behave like a normal  
raid5+(hot)spare of course.
It is not intended as a replacement for normal RAID6 but it would give  
most of your data about the same protection while maintaining the  
speed of RAID5.

*) The main speed advantage of RAID5 vs. RAID6 comes from the fact  
that if you write one physical block**) in a RAID5 you only need to  
update***) one other additional physical block. If you write a  
physical block in a RAID6 you have to read the whole stripe and then  
write the RAID6 chunk of the stripe.
**) A RAID chunk consists of several physical blocks. Several chunks  
make up a stripe.
***) read+write

Ok, I hope no one can claim a patent on it now. ;)
Alex.

========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
