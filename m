From: Luca Berra <bluca@comedia.it>
Subject: Re: Here it is again, this time all text.
Date: Wed, 3 Mar 2010 08:04:13 +0100
Message-ID: <20100303070413.GD21832@maude.comedia.it>
References: <4B8D6F4A.3040105@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8D6F4A.3040105@bellsouth.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 02, 2010 at 02:04:26PM -0600, Csaba Biegl wrote:
> 1) On machine #1 mdadm release versions 3.0.3 and 3.1.1 both fail to start 
> mdmon, therefore assembled RAID is read only. Checked out latest git 
> version of mdadm, runs array fine. After this I did not even bother with 
> release versions of mdadm on machine #2.
yes many issues related to imsm are fixed in git and scheduled for 3.1.2

> 2) On machine #2 mdadm assembles the DDF BIOS created array fine, however 
> upon shutdown it somehow updates the metadata in a way that the BIOS does 
> not recognize the arrays any more. But booting Linux again -- of course not 
> from the freshly trashed RAID :-( -- the array can be re-assembled using 
> mdadm.
are you sure you dont kill mdmon process at shutdown time?

> 3) The latest git version of mdmon has some command line processing bugs 
> that will crash the program if no container is given on the command line 
> (i.e. "mdmon --all --takeover", etc..). Patch attached.
I sent a different patch to address the same problems a couple of days
ago.

> 4) The static linked version of mdmon crashes in the forked daemon process. 
> According to "gdb mdmon core", the crash is in one of the signal handlers 
> ("wake_me") which gets called with an invalid stack pointer. To me it looks 
> like this is not mdmon's problem but rather a brain-dead static libc. Did 
> not try other environments, so I do not know whether this is Slackware 
> and/or 64 bit specific.
if you could do more tests or send in a bt it would be appreciated.

> Question:
>
> I chose a startup/initrd approach somewhat different than what is suggested 
> in the documentation. It is based on the fact that the RAID array can be 
> assembled in read-only mode just by "mdadm" without an available "mdmon". 
> Relevant steps from the initrd's init script:
>
>   mdadm -Es > /etc/mdadm.conf
this is unneeded
>   mdadm -As
>   mount -r /dev/mdXpY /mnt
>   mount -n -t tmpfs initrw /mnt/lib/init/rw
>   mkdir -p /mnt/lib/init/rw/mdadm
>   for dev in /dev/md/ddf* /dev/md/imsm*; do mdmon $dev; done
that's what --all is for
>   switch_root /mnt /sbin/init
>
> With the following links/files in place on the initrd:
>
>   /sbin/mdadm     # statically linked
>   /sbin/mdmon -> /mnt/sbin/mdmon
>   /lib64/*.so    ->   /mnt/lib64/*.so        # libraries needed by the 
> dynamically linked mdmon
>   /var/run/mdadm -> /mnt/init/rw/mdadm
>   /init/rw/mdadm -> /mnt/init/rw/mdadm
>
> And the final system also has this:
>
>   /var/run/mdadm -> /lib/init/rw/mdadm
>
> So this approach allows me to run the final system's copy of mdmon, without 
> ever having to use the '--takeover' stuff. And the mdmon "status" files are 
> always in the same place. And /var can be unmounted during shutdown. 
> Anything wrong with this? So far working fine for me...
the reason for the takeover is not moving the socket from /lib/init/rw
to /var.
mdmon running from initramfs has the text sections mapped to files on
the ram disk. we kill it and restart it in order to release these memory
areas and free the memory allocated by initramfs.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
