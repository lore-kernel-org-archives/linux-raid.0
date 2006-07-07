From: Neil Brown <neilb@suse.de>
Subject: Re: Setting up mdadm.conf for UUID?
Date: Sat, 8 Jul 2006 08:35:55 +1000
Message-ID: <17582.57803.487170.874225@cse.unsw.edu.au>
References: <6d5bedd80607070539x53df9eeet8d4ba31acb283ee5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ewan Grantham on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday July 7, ewan.grantham@gmail.com wrote:
> My RAID-5 array is composed of six USB drives. Unfortunately, my
> Ubuntu Dapper system doesn't always assign the same devices to the
> drives after a reboot. However, mdadm doesn't seem to like having an
> mdadm.conf that doesn't have a Devices line with specified device
> names.

Sure it does

  DEVICE /dev/sd*
or 
  DEVICE partitions

> 
> Anyway to setup an mdadm.conf so that it will just assemble the drives
> using the UUID of the array? Or is the trick to not have an mdadm.conf
> and add something to a runlevel script?
> 

Yes.

 DEVICE partitions
 ARRAY /dev/md0 UUID=what:ever:it:ius
 ARRAY /dev/md1 UUID=uuid:for:md:one

NeilBrown
