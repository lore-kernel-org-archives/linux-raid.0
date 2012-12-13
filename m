From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Degraded Raid6
Date: Thu, 13 Dec 2012 09:54:13 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212130942300.17599@uplift.swm.pp.se>
References: <S1754985Ab2LLT4x/20121212195656Z+425@vger.kernel.org> <20121212204907.248080@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121212204907.248080@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Waage <berndman1980@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 Dec 2012, Bernd Waage wrote:

> I run an 8-disk raid 6 on which sporadically 2 drives dropped out, that 
> I could just re-add when I zeroed the zuperblock beforehand. Recently, 
> upon re-adding those 2 drives (after the zero-superblock) a third drive 
> dropped out after 5-10 minutes of syncing. I then did a zero-superblock 
> on the third drive and tried to re-add it - which failed.

At this point, your only option is to re-create the raid superblocks via 
the --create command. Since you took your RAID6 (which can handle 2 drives 
going bad) with 2 bad drives, and then zero:ed the superblock on a third 
drive, you now have a non-working RAID6.

What did you expect to happen when you zero:ed the third drive?

I would imagine that the third drive dropped out due to read error? Why 
did the other two drives drop out?

Anyhow, you now have two options. You can re-create the raid6 with two 
missing drives, meaning you still have the read error somewhere (if that's 
what happened), and try to work around that (perhaps dd_rescue the drive 
to a non-defective drive, losing the information on the bad blocks), or 
you can decide that very little has changed since the first two drives 
dropped out, and use one of those instead of the drive with the read 
errors.

Please read up carefully regarding data mdadm versions differing with 
default data offset, chunk size etc. Recreating with --create 
--assume-clean is a big dangerous hammer that might wipe all your data. 
Mess up the order of the drives and forget --assume-clean or write to the 
array in this state, and you might destroy things.

If you value your data, be patient and make sure you understand all the 
ramifications of what you're doing. It might be a good thing to back up 
all drives before continuing (if you have the economic possibility of 
doing so).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
