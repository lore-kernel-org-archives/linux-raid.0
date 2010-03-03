From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 3.1.1 feedback
Date: Wed, 3 Mar 2010 13:01:50 +1100
Message-ID: <20100303130150.7ce572ee@notabene.brown>
References: <4B8D69DB.5010002@bellsouth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8D69DB.5010002@bellsouth.net>
Sender: linux-raid-owner@vger.kernel.org
To: Csaba Biegl <bieglc@bellsouth.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 02 Mar 2010 13:41:15 -0600
Csaba Biegl <bieglc@bellsouth.net> wrote:

> Neil (and possibly others),
> 
> Thanks for your recent work on the new in-kernel and mdadm features that 
> allow the use of non-native RAID metadata formats with Linux software 
> RAID. I recently put it to the test on two different machines. Below are 
> my experiences. Hopefully you will find them useful.
> 
> Machines:
> 
> #1: HP XW8400 with 6 port Intel SATA controller, supports IMSM. 5x250GB 
> SATA drives, set up in BIOS as RAID5, with single virtual array.
> 
> #2: Supermicro server with X7DCA-3 motherboard. SATA array connnected to 
> integrated LSI 1068E SAS controller. MB has LSI software RAID feature 
> enabled (DDF). 8x500GB SATA drives, set up in BIOS as RAID5, with 
> multiple virtual arrays.
> 
> Both machines dual boot WinXP Pro 64 and 64 bit Linux, the latter being 
> the Slackware 13.0 distro.
> 
> Observations:
> 
> 1) On machine #1 mdadm release versions 3.0.3 and 3.1.1 both fail to 
> start mdmon, therefore assembled RAID is read only. Checked out latest 
> git version of mdadm, runs array fine. After this I did not even bother 
> with release versions of mdadm on machine #2.

Fair enough.  Hopefully 3.1.2 will be out soon with all this fixed.

> 
> 2) On machine #2 mdadm assembles the DDF BIOS created array fine, 
> however upon shutdown it somehow updates the metadata in a way that the 
> BIOS does not recognize the arrays any more. But booting Linux again -- 
> of course not from the freshly trashed RAID :-( -- the array can be 
> re-assembled using mdadm.

That is going to be hard to track down.  Maybe I have some checksum
wrong but don't verify it properly when reading the metadata ...

Can you get me the output of "mdadm --examine" on each individual device
after the BIOS has just created the array, and again after mdadm has
made a mess and the BIOS doesn't recognise it any more?

> 
> 3) The latest git version of mdmon has some command line processing bugs 
> that will crash the program if no container is given on the command line 
> (i.e. "mdmon --all --takeover", etc..). Patch attached.

This has been fixed, thanks.

> 
> 4) The static linked version of mdmon crashes in the forked daemon 
> process. According to "gdb mdmon core", the crash is in one of the 
> signal handlers ("wake_me") which gets called with an invalid stack 
> pointer. To me it looks like this is not mdmon's problem but rather a 
> brain-dead static libc. Did not try other environments, so I do not know 
> whether this is Slackware and/or 64 bit specific.

You are probably right.  I probably won't try to track this down.


> 
> Question:
> 
> I chose a startup/initrd approach somewhat different than what is 
> suggested in the documentation. It is based on the fact that the RAID 
> array can be assembled in read-only mode just by "mdadm" without an 
> available "mdmon". Relevant steps from the initrd's init script:

You should be sure to test if this works after a crash - i.e. when the
filesystem is inconsistent.

In this situation, ext3fs will replay the journal even if the filesystem is
mounted read-only, so it will want to write to the device, thus necessitating 
mdmon.

If you do experiment with this, let us know how it goes please.

Thanks,
NeilBrown


> 
>    mdadm -Es > /etc/mdadm.conf
>    mdadm -As
>    mount -r /dev/mdXpY /mnt
>    mount -n -t tmpfs initrw /mnt/lib/init/rw
>    mkdir -p /mnt/lib/init/rw/mdadm
>    for dev in /dev/md/ddf* /dev/md/imsm*; do mdmon $dev; done
>    switch_root /mnt /sbin/init
> 
> With the following links/files in place on the initrd:
> 
>    /sbin/mdadm     # statically linked
>    /sbin/mdmon -> /mnt/sbin/mdmon
>    /lib64/*.so    ->   /mnt/lib64/*.so        # libraries needed by the 
> dynamically linked mdmon
>    /var/run/mdadm -> /mnt/init/rw/mdadm
>    /init/rw/mdadm -> /mnt/init/rw/mdadm
> 
> And the final system also has this:
> 
>    /var/run/mdadm -> /lib/init/rw/mdadm
> 
> So this approach allows me to run the final system's copy of mdmon, 
> without ever having to use the '--takeover' stuff. And the mdmon 
> "status" files are always in the same place. And /var can be unmounted 
> during shutdown. Anything wrong with this? So far working fine for me...
> 
> Thanks,
> 
> Csaba Biegl
> bieglc@bellsouth.net
> 
> 
> 
> 
> 
> 

