From: Andre Noll <maan@systemlinux.org>
Subject: Re: A random initramfs script
Date: Fri, 17 Mar 2006 02:22:45 +0100
Message-ID: <20060317012245.GD14051@skl-net.de>
References: <87u0a0so6w.fsf@hades.wkstn.nix> <20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix> <20060315185750.GP27173@skl-net.de> <17432.59463.266472.266509@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17432.59463.266472.266509@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15:23, Neil Brown wrote:

> You shouldn't need portmap to mount an NFS filesystem unless you
> enable locking,

That's news to me, thanks for pointing it out. But I do need portmap
for mounting a NFS filesystem read-only (/usr, which contains
portmap). Is that correct?

> > He likes to compare the situation with /etc/fstab. Nobody complains
> > about having to edit /etc/fstab, so why keep people complaining about
> > having to edit /etc/mdadm.conf?
> 
> Indeed!  And if you plug in some devices off another machine for
> disaster recovery, you don't want another disaster because you
> assembled the wrong arrays.

How is such a disaster possible, given each md device contains an
ID for the array it belongs to? But yes, it is certainly a good
idea to doublecheck everything before assembling the array in such
a recovery situation.

> I would like an md superblock to be able to contain some indication of
> the 'name' of the machine which is meant to host the array, so that
> once a machine knows its own name, it can automatically find and mount
> its own arrays, but that isn't near the top of my list of priorities
> yet.

How about a user-defined name?

	mdadm --create --name the_extra_noisy_array /dev/md0 --level...

would use some fixed algorithm to compute a usual UUID for the new
array from the string "the_extra_noisy_array", and

	mdadm --assemble /dev/md0 --name the_extra_noisy_array

could use the same algorithm and take into account only those devices
which have a UUID equal to the computed one.

Just a thought.
Andre
-- 
The only person who always got his work done by Friday was Robinson Crusoe
