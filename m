From: dean gaudet <dean@arctic.org>
Subject: Re: how to clone a disk
Date: Sat, 11 Mar 2006 16:15:33 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603111608480.21574@twinlark.arctic.org>
References: <1142038562.20484.234.camel@localhost.localdomain>
 <dd43dcfb0603110353g1a4d51f6y9fe4caa4007b6e9c@mail.gmail.com>
 <1142114892.27020.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1142114892.27020.7.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: "Paul M." <paul@gpmidi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 11 Mar 2006, Ming Zhang wrote:

> On Sat, 2006-03-11 at 06:53 -0500, Paul M. wrote:
> > Since its raid5 you would be fine just pulling the disk out and
> > letting the raid driver rebuild the array. If you have a hot spare
> 
> yes, rebuilding is the simplest way. but rebuild will need to read all
> other disks and write to the new disk. when serving some io at same
> time, the rebuilding speed is not much,
> 
> but if i do a dd clone and plug it back. the total traffic is copy one
> disk which can be done very fast as a fully sequential workload. with
> that bitmap feature, the rsync work after plugging back is minor.
> 
> so the one disk fail window is pretty small here. right?

you're planning to do this while the array is online?  that's not safe... 
unless it's a read-only array...

if you've got a bitmap then one thing you *could* do is stop the array 
temporarily, and copy the bitmap first, then restart the array... then 
copy the rest of the disk minus the bitmap.

you basically need an atomic copy of the bitmap from before you start the 
ddrescue... and you need to use that copy of the bitmap when you 
reassemble the array with the new disk.

or you could stop the raid5, and make a raid1 (legacy style, without raid 
superblock) of the dying disk and the new disk... then reassemble the 
raid5 using the raid1 for the one component... then restart the raid5.

regardless of which method you use you're going to need to take the array 
offline at least once to reassemble it with the duplicated disk in place 
of the dying disk...

i think i'd be tempted to do the raid1 method ... because that one 
requires you go offline at most once -- after the raid1 syncs you can fail 
out the dying drive and leave the raid1 around "degraded" until some 
future system maintenance event where you can reassemble without it.  (a 
reboot would automagically make it disappear too -- because it wouldn't 
have a raid1 superblock anyhow).

-dean
