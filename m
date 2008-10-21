From: David Greaves <david@dgreaves.com>
Subject: Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 09:38:17 +0100
Message-ID: <48FD94F9.3060400@dgreaves.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gdj1c4$8nf$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org, Jon Nelson <jnelson-linux-raid@jamponi.net>, neilb@suse.de
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Jon Nelson <jnelson-linux-raid@jamponi.net> wrote:
>> I was wondering about proactive drive replacement.
> [bitmaps, raid1 drive to replace and new drive, ...]
> 
> I belive to remember a HowTo going over this list somewhere in the past
> (early bitmap times?) which was recommending exactly your way.
> 
>> The problem I see with the above is the creation of the raid1 which
>> overwrites the superblock. Is there some way to avoid that (--build?)?
> 
> You can build a RAID1 without superblock.

How nice, an independent request for a feature just a few days later...

See:
   "non-degraded component replacement was Re: Distributed spares"
http://marc.info/?l=linux-raid&m=122398583728320&w=2

It references Dean Gaudet's work which explains why the above scenario, although
it seems OK at first glance, isn't good enough.

The main issue is that the drive being replaced almost certainly has a bad
block. This block could be recovered from the raid5 set but won't be.
Worse, the mirror operation may just fail to mirror that block - leaving it
'random' and thus corrupt the set when replaced.
Of course this will work in the happy path ... but raid is about correct
behaviour in the unhappy path.

If you could force the mirroring to complete and note the non-mirrored blocks
then you could fix it by identifying the bad/unwritten block on the new device
in a raid set and manually set the bitmap for the area around that block to be
'dirty' and force it to be rebuilt from the remaining disks.

Actually, this would be a nice thing to do as a subset of the feature to force a
re-write of SMART identified badblocks using parity calculated values.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
