From: danci@agenda.si
Subject: Re: "failed-disk" ?
Date: Fri, 21 Mar 2003 08:38:49 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303210828520.10546-100000@duplo.agenda.si>
References: <20030320213253.GP13201@rdlg.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030320213253.GP13201@rdlg.net>
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 20 Mar 2003, Robert L. Harris wrote:

>
>
> No but according to the RAID HOWTO it says it's a valid keyword for when
> you need to build a mirror with a failed/missing disk (i.e. converting
> root to raid and can't kill your existing /)

It is, but:

'failed-disk' replaces 'raid-disk' to inform the md driver, that a device
'/dev/sda1' should not be automatically synchronized.

This gives you an operative array in degraded mode, so you can copy files
from your current root to your new degraded array.

You have to change the file /etc/fstab (on the NEW filesystem) to use
/dev/md0 for root, arrange the boot manager (lilo, grub, whatever) to boot
with the new root (/dev/md0), reboot and 'un-fail' :) (or add) /dev/sda1
to the array (using mdadm or raidhotadd).


  D.


>
>
> Thus spake Lars Marowsky-Bree (lmb@suse.de):
>
> > On 2003-03-20T16:22:50,
> >    "Robert L. Harris" <Robert.L.Harris@rdlg.net> said:
> >
> > > I'm trying to "mkraid /dev/md1" with the following:
> > >
> > > raiddev /dev/md1
> > >   raid-level 1
> > >   nr-raid-disks 2
> > >   nr-spare-disks 0
> > >   chunk-size 16
> > >   persistent-superblock 1
> > >   device failed-disk
> > >   raid-disk 0
> > >   device /dev/sdb1
> > >   raid-disk 1
> > >
> > > I'm trying to convert this machine to raid1 on root.  Don't ask about
> > > the md1, long story.  At any rate when I do the mkraid I get this:
> > >
> > > root@rharris-build2:~# mkraid /dev/md1
> > > handling MD device /dev/md1
> > > analyzing super-block
> > > couldn't call stat() on device failed-disk -- No such file or directory
> > > mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
> >
> > Does your system have a device named 'failed-disk' ? I would assume not ;-)
> >
> >
> > Sincerely,
> >     Lars Marowsky-Br?e <lmb@suse.de>
> >
> > --
> > SuSE Labs - Research & Development, SuSE Linux AG
> >
> > "If anything can go wrong, it will." "Chance favors the prepared (mind)."
> >   -- Capt. Edward A. Murphy            -- Louis Pasteur
>
> :wq!
> ---------------------------------------------------------------------------
> Robert L. Harris                     | PGP Key ID: E344DA3B
>                                          @ x-hkp://pgp.mit.edu
> DISCLAIMER:
>       These are MY OPINIONS ALONE.  I speak for no-one else.
>
> Diagnosis: witzelsucht
>
> IPv6 = robert@ipv6.rdlg.net	http://ipv6.rdlg.net
> IPv4 = robert@mail.rdlg.net	http://www.rdlg.net
>

-- 
___________________________________________________________________
|    Danilo Godec    |     Agenda d.o.o.    |   ISP for business  |
|  jr. Syst. Admin   |    Gosposvetska 84   |     WAN networks    |
|  danci@agenda.si   |    si-2000 Maribor   |  Internet/Intranet  |
| tel:+386.2.2340860 |       Slovenija      | Application servers |
| fax:+386.2.2340854 | http://www.agenda.si |  Caldera OpenLinux  |


