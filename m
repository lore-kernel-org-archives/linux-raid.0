From: dean gaudet <dean@arctic.org>
Subject: Re: Raid 0 breakage (maybe)
Date: Mon, 30 Oct 2006 03:35:03 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0610300318330.22910@twinlark.arctic.org>
References: <1162100400.17928.9.camel@stoneburner.xwredwing.net>
 <17733.9523.946779.424799@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17733.9523.946779.424799@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Matt Thrailkill <matt@modestolan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 30 Oct 2006, Neil Brown wrote:

> > root@stoneburner:~# mdadm --assemble /dev/md0 /dev/hde /dev/hdi
> > mdadm: cannot open device /dev/hde: Device or resource busy
> 
> This is telling you that /dev/hde - or one of it's partitions - is
> "Busy".  This means more than just 'open'.  It means mounted or
> included in an md or dm array, or used for swap.
> You need to find out what is keeping it busy.
> Most likely dm or md.

it's probably evms+ubuntu+new kernel stupidity.

as far as i've determined, older (dapper) ubuntu had evms as part of the 
base package requirements.  evms was set up in some promiscuous manner 
where it goes and sets up dm linear maps for every damn partition and 
device.  nobody cared before because older kernels don't seem to stop 
people from using the underlying /dev/foo for md or mount or whatever. but 
newer kernels don't allow that any more.

it looks like they dropped the evms requirement in edgy -- probably 
because it has the newer kernel... but people who upgraded from dapper 
will run into this because they'll still have evms from before.


> I don't know much about dm - is there some 'pvlist' command or similar
> that will show all the phys volumes it is holding on to..

"dmsetup ls" does that...

for example on an ubuntu box i haven't fixed yet:

# dmsetup ls --tree
hda5 (253:1)
 `- (3:0)
hda1 (253:0)
 `- (3:0)

you can "dmsetup remove hda1" or whatever to get back the real device (but 
it's better to just remove or disable evms and reboot).

-dean

