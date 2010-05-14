From: Daniel Reurich <daniel@centurion.net.nz>
Subject: RE: Broken RAID1 boot arrays
Date: Fri, 14 May 2010 19:08:55 +1200
Message-ID: <1273820935.5140.2770.camel@localhost.localdomain>
References: <7A.77.20538.06CBCEB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7A.77.20538.06CBCEB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2010-05-13 at 21:58 -0500, Leslie Rhorer wrote:
> > > ~ # mount -o -v  /dev/md1 /target
> > > mount: mounting /dev/md1 on /target failed: Invalid argument
> > 
> > > 	So now, what?  I can mount the arrays just fine under the Ubuntu
> > > live CD, but not this one.
> > 
> > For a start don't use -o unless your specifying options like rw,bind
> > etc.
> 
> 	I misread the man page (it did seem rather odd), but it doesn't
> matter.  When I first tried, it was without any switches.  I tried
> specifying the fs type.  I tired updating the fstab file and using `mount
> -a`.  It read the file just fine, but still gives me the same error.
> 
>  
> > What type of filesystem is it?
> > 
> > Try "mount -v /dev/md1 /"

Sorry.  Should have been "mount -v /dev/md1 /target" - assuming /dev/md1
is your root filesystem.
> 
> 	It doesn't matter what switches I try, it always gives me that
> error.  The md1 array (/boot) is ext2, and the md2 array (/) is ext3.

you did "mkdir /target"  didn't you?  Can verify it is there? 
> 
> > > > 13) bind mount the dev sys and proc virtual filesystems:
> > > > 	"mount -o bind /dev /target/dev"
> > > > 	"mount -o bind /sys /target/sys"
> > > > 	"mount -o bind /proc /target/proc"
> > > > 14) Chroot: chroot /target /bin/bash
> > > > 15) mount /boot /usr /var as needed.
> > > > 16) update your mdadm.conf and /etc/fstab etc (ideally use labels for
> > > > root and boot or fs UUID's)
> 
> 	The mdadm.conf file already employs UUIDs for the RAID arrays.  In
> the man page, I don't see a way to specify the device by UUID, but by my
> reading "DEVICE partitions" should work.  It won't help to specify the array
> UUID in fstab if mdadm won't assemble the arrays.
> 
> , and any other stuff like installing the
> > > > latest mdadm (apt|aptitude should work fine if your internet
> > connected).
> > 
> > > 	Uh-uh, again.  Neither apt-get nor aptitude seem to be on the CD, at
> > > least not when installing this way.
> > 
> > But your in the chroot, and most of the normal tools in your system are
> > use able.
> 
> 	No, I'm not.  Remember?  I can't mount /target (/dev/md2) so I can't
> chroot to it:
> 
> ~ # chroot /target /bin/bash
> chroot: cannot execute /bin/bash: No such file or directory
> 
> 	Everything in your method requires me to be able to mount the / and
> /boot file systems.  Hmm.  The only thing I can't do under the Ubuntu CD is
> assemble and mount the swap, so this should work using the Ubuntu CD...
> 
> > > > > 	It's also really odd that I can assemble and mount the root
> > and boot
> > > > > arrays, but under Ubuntu I can't even assemble the swap array.  It
> > > > complains
> > > > > that the first member of the array is busy and refuses to start
> > > > /dev/md3.
> > > > > The results of --examine look identical to those listed below,
> > except of
> > > > > course for the partition specific entries (size, drive and array
> > UUID,
> > > > > events, etc).
> > > > >
> > > > This is because ubuntu probably picks up the first swap partition it
> > > > finds and uses it.
> > >
> > > 	It doesn't mention it when I issue `mount` or lsof.  What's more, it
> > > gives the same error for both partitions.  Also, as I mentioned, it
> > doesn't
> > > show any errors when I issue `sudo mdadm --examine [sda3|sdb3]`.
> > Finally,
> > > it assembles without complaint under the Debian live CD.
> > >
> > > > It seems odd to me that all the raid volumes are named "Backup".
> > > > Perhaps mdadm doesn't like the name collision.
> > >
> > > 	First of all, isn't that the homehost name?  If so, it is *SUPPOSED*
> > > to be the same for all three.  Secondly, it assembled just fine under
> > the
> > > old kernel and mdadm, as I mentioned.  Thirdly, if it were the case, I
> > would
> > > expect it to assemble at least the first target without complaint.
> > Finally,
> > > the names aren't the same.  They are 'Backup':1, 'Backup':2, and
> > 'Backup':3
> > >
> > Nope.  I suspect you've mistaken the mdadm option -N or --name for
> > --hostname.
> 
> 	No, I'm just reading what's in the superblock (via --examine) which
> is what is used to populate the mdadm.conf file.  I did not use the --name
> option when I created the arrays, but the HOMEHOST <system> line was in
> mdadm.conf when I created them.
> 
> 
> > The name should be specific to the individual arrays and hostname is for
> > saying these arrays belong to this host.
> > 
> > > > Perhaps you need to recreate some of them with a different name.  I'd
> > > > suggest recreating the raid1 volumes with different names and the
> > > > --assume-clean flag (except the swap one which won't be since the
> > ubuntu
> > > > live cd's been messing with one of those component partitions).
> > >
> > > 	I think before I try something like that, I would just trash one
> > > element of each array, assemble the arrays broken with just one element,
> > and
> > > copy over the files to the "new" partitions, and go from there.
> > Alternatively recreate the arrays with a missing drive and add that once
> > your satisfied the data is still their in the new array.
> > 
> > >
> > > > I hope this helps.
> > >
> > > 	Well, I'm getting somewhere.  I'm just not sure where, if I can't
> > > get mount to work.
> > >
> > I hope I've solved that one for you.
> 
> 	You mean by mounting the device so I can chroot so that mount will
> work?  Uh... no.  I can't fix the mount utility by doing anything which
> first requires me to use the mount utility.  If you mean not using the -o
> option, then no, that doesn't make any difference, either.  Nor does the -v
> option appear to do anything.  The `mount` command never returns anything
> but "mounting xxxx on yyyy failed: Invalid argument", unless I issue:
> 
> ~ # mount --help
> BusyBox v1.14.2 (Debian 1:1.14.2-2) multi-call binary
> 
> Usage: mount [flags] DEVICE NODE [-o OPT,OPT]
> 
> 	which isn't really very helpful.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



