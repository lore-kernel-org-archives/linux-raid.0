From: Evan Felix <evan.felix@pnl.gov>
Subject: Re: mount-by-label finds drive not array ????
Date: Tue, 06 Jul 2004 08:55:11 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089129311.3463.23.camel@e-linux>
References: <Pine.LNX.4.58.0407010736180.15444@jupiter.toms.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <Pine.LNX.4.58.0407010736180.15444@jupiter.toms.net>
To: Tom Oehser <tom@toms.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've always found the mount by Label system to be a little confused
about things.  My specific issues cam from haveing devfs turned on in
the kernel, but not mounting it.

Basically the mount code scans /proc/partitions and examines each one in
turn,  which usually lists devices as the were 'discovered' or in the
order device drivers were loaded.  so it sounds like the IDE drives come
up first, a valid label is found, and it tries to mount it.  if you
could magically load the md code before your ide code it would find it
first.(build the raid code into your kernel?)

I would suggest avoiding mount by label like the plauge, but thats just
me.  It just consuses things, doesent always work and makes reading
/etc/fstab confusing.

Evan

On Thu, 2004-07-01 at 04:41, Tom Oehser wrote:
> Hi,
> 
> I'm accustomed to doing something like:
> 
> LABEL=tomsvol2  /mnt/foo   ext3      defaults        0 2
> 
> But if I do that on my raid-5 md arrays, it tries to mount
> disk 1 of the 4 disks that make up the array!  Apparently,
> the first stripe has enough of the filesystem that it must
> be thinking that is what to mount!  Even with type "FD"!!!
> 
> So, with an array /dev/md0 made of hda1 hdb1 hdc1 hdd1, I
> am having to do a literal:
> 
> /dev/md0        /mnt/bar      ext3      defaults        0 4
> 
> Since if I do it by "LABEL=", it tries to mount hda1, not md0!
> 
> Is this just a known/accepted brain-deadness of the mount code?
> 
> -Tom
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
