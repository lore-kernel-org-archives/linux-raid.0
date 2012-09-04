From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: Problems after extending partition [SOLVED]
Date: Tue, 04 Sep 2012 16:29:48 -0700
Message-ID: <1346801388.11821.22.camel@corn.betterworld.us>
References: <504009DF.4070408@biostat.ucsf.edu>
	 <5040178C.1070900@websitemanagers.com.au>
	 <1346473267.11608.14.camel@corn.betterworld.us>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1346473267.11608.14.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2012-08-31 at 21:21 -0700, Ross Boylan wrote:
> On Fri, 2012-08-31 at 11:46 +1000, Adam Goryachev wrote:
> > On 31/08/12 10:48, Ross Boylan wrote:
> > > /dev/md1 was RAID 1 built from hda3 and hdb3.  After increasing the
> > > partition size of hd[ab]3, md1 could not be assembled.  I think I
> > > understand why and have a solution, but I would appreciate it if
> > > someone could check it.  This is with 0.90 format on Debian Lenny with
> > > the partitions in raid auto-detect mode.  hda and hdb are virtual
> > > disks inside a kvm VM; it would be time-consuming to rebuild it from
> > > scratch.
> > >
> > > The final wrinkle is that when I brought the VM up and dm1 was not
> > > constructed one of the partitions was used anyway, so they are now out
> > > of sync.
> > >
> > > Analysis: Growing the partitions meant that the mdadm superblocks were
> > > not at the expected offset from the end of the partitions, and so they
> > > weren't recognized as part of the array.

[description of a possible solution and problems preserving the UUID
when using mdadm in squeeze deleted]

Since the more recent mdadm insisted on tweaking my uuid with a home
host, I did it from early in the boot process for the lenny VM.

Set the break=mount option for system startup.  This is a Debianism, I
think.  It also requires the use of an initrd.

This drops you into a shell.
modprobe md    # essential
#lenny uses hda not sda for disk name
mdadm --create /dev/md1 --uuid=6f05ff4e:b4d49c1f:7fa21d88:ad0c50a9 =0.90 --level=mirror --raid-devices=2 /dev/hdb3 missing
mdadm --manage /dev/md1 --add /dev/hda3
mdadm --wait /dev/md1

Restarted the VM (not sure if necessary).


Although mdadm has some commands for --grow'ing the size of the md, I
did not need to use any of them.  Possibly that's because I used RAID1.
Can anyone comment?

For completeness, the final steps were
pvresize /dev/md1  # makes the PV fill the whole md1
lvextend -L+1G myvg/usr  # grow an LV that needed more room
resize2fs /dev/myvg/usr  # online resize of filesystem

This is for ext3 on top of LVM on top of RAID.

Ross


