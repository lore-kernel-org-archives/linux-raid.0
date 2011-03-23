From: NeilBrown <neilb@suse.de>
Subject: Re: RAID-5 and mdadm --assemble troubleshooting
Date: Wed, 23 Mar 2011 11:04:46 +1100
Message-ID: <20110323110446.34c241ea@notabene.brown>
References: <AANLkTikjFZnEoRWAiY3SsmxH6kci25iQQXogMyKTuUGF@mail.gmail.com>
	<20110322092808.31d545c6@notabene.brown>
	<AANLkTinTa95dNBwdVqyjhd6RWJdciwPRr3=BXA-T5Hv6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinTa95dNBwdVqyjhd6RWJdciwPRr3=BXA-T5Hv6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: A J Wyborny <ajwyborny@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Mar 2011 17:42:33 +0100 A J Wyborny <ajwyborny@gmail.com> wr=
ote:

> Wow, thank you so much.  I forgot to mention that I AM running mdadm
> v3.1.4, compiled from source, after initially running the Ubuntu
> default of 2.6.7.1.  I'm not sure why the "start_dirty_degraded" file
> wasn't updated, but I'm glad I know about it now.

I thought it was fixed in 3.1.4... apparently not quite.  Your particul=
ar
case was a bit unusual and slip through the tests.  I've added a fix wh=
ich
will be in 3.1.5 and 3.2.1.

'start_dirty_degraded' is only intended to be used when arrays are
auto-assembled by the kernel (a practice that I don't encourage).
I suggested it's use here as a work around for the bug in mdadm rather =
than
the appropriate way to generally deal with your situation. It won't be =
needed
in future mdadm releases.

Thanks,
NeilBrown


>=20
> My attempts to re-add /dev/sda1 to the array right away failed, but a
> reboot took care of that problem and it's now recovering.
>=20
> Again, I really appreciate it.
>=20
> Adam
>=20
> On Mon, Mar 21, 2011 at 11:28 PM, NeilBrown <neilb@suse.de> wrote:
> > On Mon, 21 Mar 2011 23:08:40 +0100 A J Wyborny <ajwyborny@gmail.com=
> wrote:
> >
> >> Hi all,
> >>
> >> After exhausting my efforts with google searches and linux-raid IR=
C
> >> chats, I'm reaching out to you all for some help with why I can't
> >> assemble a broken RAID-5 configuration. =A0My initial problem, I'v=
e
> >> determined, was caused by a faulty PCI-E SATA controller card. =A0=
I
> >> would constantly lose access to my mounted RAID volume (/home) at
> >> random times and increasingly during high write accesses. =A0In th=
e past
> >> a reboot and running "mdadm --assemble --force --scan" would solve=
 the
> >> issue. =A0This time, no such luck. =A0In the process of troublesho=
oting I
> >> also fat-fingered an "mdadm --assemble" command and lost the
> >> superblock of my /dev/sda1 partition, which isn't helping things
> >> either.
> >>
> >> The SMART status is clean on all disks.
> >>
> >> I really appreciate any thoughts/input you might have.=A0 -Adam
> >>
> >> Here's my setup:
> >>
> >> RAID-5 array with four 1.5TB disks (/dev/sda1, /dev/sdb1, /dev/sdd=
1, /dev/sde1)
> >> /dev/sdc is my root and swap partitions
> >> /dev/md0 should be mounted to /home
> >>
> >> Results:
> >> root@focalor:~# cat /proc/mdstat
> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid=
5]
> >> [raid4] [raid10]
> >> unused devices: <none>
> >> root@focalor:~# mdadm -vv --assemble --force --scan
> >> mdadm: looking for devices for /dev/md0
> >> mdadm: cannot open device /dev/sdc1: Device or resource busy
> >> mdadm: /dev/sdc1 has wrong uuid.
> >> mdadm: no RAID superblock on /dev/sda1
> >> mdadm: /dev/sda1 has wrong uuid.
> >> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> >> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> >> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
> >> mdadm: no uptodate device for slot 0 of /dev/md0
> >> mdadm: added /dev/sdd1 to /dev/md0 as 2
> >> mdadm: added /dev/sde1 to /dev/md0 as 3
> >> mdadm: added /dev/sdb1 to /dev/md0 as 1
> >> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> >
> > You are hitting an mdadm bug fixed in 2.6.9 by
> >
> > http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D4e9a6ff778c=
dc58dcc6897e74cf5ee1d3f73e1f7
> >
> > What version of mdadm are you running?
> >
> > You can work around it by
> > =A0echo 1 > /sys/module/md_mod/parameters/start_dirty_degraded
> >
> > before running the 'mdadm -A' command.
> >
> >
> >> dmesg output:
> >> http://pastebin.com/usrzvmpn
> >>
> >> mdadm -E output:
> >> http://pastebin.com/vnaamC75
> >
> > It is OK - even encouraged - to include this content directly in th=
e Email.
> > That makes it easier to reference in a reply, should that be helpfu=
l.
> >
> > NeilBrown
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
