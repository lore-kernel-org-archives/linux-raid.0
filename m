From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bootable Raid-1
Date: Wed, 2 Feb 2011 11:36:12 -0600
Message-ID: <99.38.07087.F06994D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTikmDeRgwHSenFb3KFdk993jGhy_oCoV3SZN+gmo@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikmDeRgwHSenFb3KFdk993jGhy_oCoV3SZN+gmo@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: hansbkk@gmail.com [mailto:hansbkk@gmail.com]
> Sent: Wednesday, February 02, 2011 9:57 AM
> To: lrhorer@satx.rr.com
> Cc: naira@faccat.br; linux-raid@vger.kernel.org
> Subject: Re: Bootable Raid-1
> 
> On Wed, Feb 2, 2011 at 4:53 AM, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> >  I recall reading very recently (it might have even been today) that
> Linux RAID Autodetect partitions can cause problems.  I have mine set to
> simply "Linux".
> 
> I haven't come across this at all, and have never had any problem
> booting even older Linux kernels in RAID1 arrays using grub2.
> 
> >> >> I am using grub as bootloader.
> 
> You didn't specify grub2

	I didn't specify anything.  I'm not having a problem.

> You're not actually partitioning the mdX block device are you? I've
> always set up my component partitions, created the array using those
> partitions, and then created the filesystem on the mdX.

	Judging by his original message, I don't think he is partitioning
the arrays, no.

> All of my systems now boot via grub2 into RAID1s. I usually set up my
> partitioning so that every drive is exactly the same, the first
> primary is used as the boot RAID1, and the RAID5/6 component
> partitions used for the main storage Lvs are often logical inside
> extended for flexibility.

	I prefer booting from relatively small partitioned drives and
keeping a separate target (an array, if the system is large) for data.  My
servers have RAID1 arrays for booting.


