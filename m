From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: draft howto on making raids for surviving a disk crash
Date: Thu, 7 Feb 2008 10:12:19 +0100
Message-ID: <20080207091219.GA7674@rap.rap.dk>
References: <20080202194131.GA7875@rap.rap.dk> <20080206090557.GA19764@percy.comedia.it> <20080206154538.GC16090@rap.rap.dk> <20080207080503.GA7665@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080207080503.GA7665@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 07, 2008 at 09:05:04AM +0100, Luca Berra wrote:
> On Wed, Feb 06, 2008 at 04:45:39PM +0100, Keld J=F8rn Simonsen wrote:
> >On Wed, Feb 06, 2008 at 10:05:58AM +0100, Luca Berra wrote:
> >>On Sat, Feb 02, 2008 at 08:41:31PM +0100, Keld J=F8rn Simonsen wrot=
e:
> >>>Make each of the disks bootable by lilo:
> >>>
> >>>  lilo -b /dev/sda /etc/lilo.conf1
> >>>  lilo -b /dev/sdb /etc/lilo.conf2
> >>There should be no need for that.
> >>to achieve the above effect with lilo you use
> >>raid-extra-boot=3Dmbr-only
> >>in lilo.conf
> >>
> >>>Make each of the disks bootable by grub
> >>install grub with the command
> >>grub-install /dev/md0
> >
> >I have already changed the text on the wiki. Still I am not convince=
d it=20
> >is the best advice that is described.
> >
> lilo -b /dev/md0 (without a raid-extra-boot line in lilo.conf) will
> install lilo on the boot sector of the partitions containing /dev/md0
> (and it will break with 1.1 sb)

I think 1.1 Superblocks will break all boots with lilo and grub,
but 1.1 superblocks are not standard in current distributions.

When would 1.1 superblocks be a problem, for new users of raid?

> for grub, do you have any doubt about the grub-install script not
> working correctly?

No, I think the grub description is OK. I only meant the lilo
description.

Best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
