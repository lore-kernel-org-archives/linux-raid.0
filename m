From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: Moving RAID 1 array to new server
Date: Tue, 11 Nov 2003 19:29:17 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-bordad$avv$1@cartman.spoiled.org>
References: <1068509010.907.4.camel@forbidden.jrc.net>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jean-Rene Cormier <jrc@vgmidi.com> wrote:
> I just moved my RAID 1 array to a new server and I did the mistake of
> moving only one disk at first to make sure that I would still have a
> copy on the other server in case the new one couldn't read the array for
> some reason. When I added the second disk it mark it as faulty or
> something so I tried to remove it from the array and re-add it but it
> added a spare drive instead. So now my array is running in degraded
> mode, what can I do to so the second drive resync with the other one?

It should work work with something like this:

mdadm --manage /dev/md0 --add /dev/hdXy

where hdXy ist the partition you want to add.

Cheers,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

