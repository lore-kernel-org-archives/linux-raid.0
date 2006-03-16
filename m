From: Neil Brown <neilb@suse.de>
Subject: Re: A random initramfs script
Date: Thu, 16 Mar 2006 15:23:35 +1100
Message-ID: <17432.59463.266472.266509@cse.unsw.edu.au>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
	<20060315002527.GO27173@skl-net.de>
	<87lkvcrtzu.fsf@hades.wkstn.nix>
	<20060315185750.GP27173@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Wednesday March 15
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Nix <nix@esperi.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 15, maan@systemlinux.org wrote:
> On 08:29, Nix wrote:
> > I try to avoid running daemons out of initramfs, because all those daemons
> > share *no* inodes with anything else you'll ever run: more permanent memory
> > load for as long as those daemons are running, although at least it's
> > swappable load.
> 
> Fair enough, but portmap is needed to mount NFS filesystems. How much
> memory would be saved if I'd kill portmap after the mount and restart
> it afterwards from a mounted filesystem?
> 

You shouldn't need portmap to mount an NFS filesystem unless you
enable locking, and you shouldn't enable nfs locking on the root
filesystem, so you shouldn't need portmap in the initramfs.


> > > The following works pretty well for me:
> > > 
> > > 	echo "DEVICE /dev/hd*[0-9] /dev/sd*[0-9] /dev/md[0-9]" > /etc/mdadm.conf
> > > 	mdadm --examine --scan --config=/etc/mdadm.conf  >> /etc/mdadm.conf
> > > 	mdadm --assemble --scan
> > 
> > Yeah, that would work. Neil's very *emphatic* about hardwiring the UUIDs of
> > your arrays, though I'll admit that given the existence of --examine --scan,
> > I don't really see why. :)
> 
> He likes to compare the situation with /etc/fstab. Nobody complains
> about having to edit /etc/fstab, so why keep people complaining about
> having to edit /etc/mdadm.conf?

Indeed!  And if you plug in some devices off another machine for
disaster recovery, you don't want another disaster because you
assembled the wrong arrays.

I would like an md superblock to be able to contain some indication of
the 'name' of the machine which is meant to host the array, so that
once a machine knows its own name, it can automatically find and mount
its own arrays, but that isn't near the top of my list of priorities
yet.


NeilBrown
