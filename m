From: Alexander <freebsd@nagilum.org>
Subject: Re: why should I "initialize" JBOD disks?
Date: Fri, 20 May 2011 21:08:59 +0200
Message-ID: <20110520210859.153715dz67pr90zk@cakebox.homeunix.net>
References: <20110520133244.GA13330@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520133244.GA13330@apartia.fr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Message from vindex+lists-linux-raid@apartia.org ---------
     Date: Fri, 20 May 2011 15:32:44 +0200
     From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
  Subject: why should I "initialize" JBOD disks?
       To: linux-raid@vger.kernel.org


> Hi,
>
> I just installed an Adaptec SAS 4805 and plugged 8 disks previously used
> "as is" (no raid) on an LSI adapter but none are recongnized as boot
> disk ("no bios installed").
>
> It seems I need to "initialize" (read: wipe) them in the Adaptec bios
> menu before being able to use them as JBOD.
>
> What the fuck?!

The controller puts the configuration details for the disk on the disk  
itself. That way you can plug the disk into another port or controller  
of the same brand and it will simply work.

> By my defintion JBOD should means "just get out of the way and let me
> use my disks as they are".
>
> Does that "initlialization" mean that disks become unusable when plugged
> to an adapter of any other brand or model?

It will show as uninitialized.

> What is the underlying format of JBOD disks. Can they be read by a
> straight, non-raid adapter?

The configuration needs to be stored somewhere on the disk. Either at  
the beginning or at the end (or a combination of both).
Hence I would expect the start of the disk to be shifted a bit (what  
used to be block 0 on the disk while plugged into the RAID controller  
will be some higher block) or the disk will "end" a bit before the  
actual end of the disk.
So I'm pretty sure you can dd such a disk onto another one to rescue  
the data given the right seek offset.
Alex.

----- End message from vindex+lists-linux-raid@apartia.org -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/ Mac (PPC): MacOS-X / Linux / MacOS-X #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
