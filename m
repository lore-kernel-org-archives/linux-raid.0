From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Wed, 8 Apr 2009 16:31:47 +1000
Message-ID: <18908.17619.375078.291547@notabene.brown>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com>
	<87tz51dmmu.fsf@frosties.localdomain>
	<FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com>
	<155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
	<87prfof1bp.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Wednesday April 8
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Doug Ledford <dledford@redhat.com>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 8, goswin-v-b@web.de wrote:
> "NeilBrown" <neilb@suse.de> writes:
> >
> > Why /var/run cannot be mounted from tmpfs nice and early too I don't know..
> 
> Because /var is not yet mounted.

I guess that is a credible answer.

We really want "/volatile" rather than "/var" for holding "run" and
"locks"..  and /tmp.
I guess that is rather unlikely to happen universally.

> 
> Maybe mdadm should just have
> 
>   -m, --map <file>
>      Filename of the map file for incremental operations. Defaults
>      to /var/run/mdadm.map. Note that the default path might not exist
>      or be read-only early in the boot process in which case a
>      suitable alternative must be specified.
> 
> Wouldn't that be more flexible?
> 
> Debian could then set 'MAP /lib/init/rw' in its mdadm.conf.

Adding a config option because we cannot agree on a standard isn't my
idea of a good time...

I'm leaning towards:

 - to open for reading, if /var/run/mdadm/map doesn't exist,
   try /dev/.mdadm.map
 - to open for writing, if opening /var/run/mdadm/map and
   /var/run/mdadm.map for writing fails, try /dev/.mdadm.map

Note that I don't want to put the file in /dev/md/ as that might not
exist yet either.

So the idea is to still use /var/run/mdadm{.,/}map, but fall back on
/dev/.mdadm.map if that is the only option.

Thought?

NeilBrown
