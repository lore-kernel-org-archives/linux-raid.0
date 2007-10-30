From: "Greg Cormier" <gcormier@gmail.com>
Subject: Re: Superblocks
Date: Tue, 30 Oct 2007 12:06:38 -0400
Message-ID: <29a863790710300906w497c0f35yb90c36dadbd2c5e7@mail.gmail.com>
References: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>
	 <18214.45758.794247.651163@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18214.45758.794247.651163@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Which is the default type of superblock? 0.90 or 1.0?

On 10/30/07, Neil Brown <neilb@suse.de> wrote:
> On Friday October 26, gcormier@gmail.com wrote:
> > Can someone help me understand superblocks and MD a little bit?
> >
> > I've got a raid5 array with 3 disks - sdb1, sdc1, sdd1.
> >
> > --examine on these 3 drives shows correct information.
> >
> >
> > However, if I also examine the raw disk devices, sdb and sdd, they
> > also appear to have superblocks with some semi valid looking
> > information. sdc has no superblock.
>
> If a partition starts a multiple of 64K from the start of the device,
> and ends with about 64K of the end of the device, then a superblock on
> the partition will also look like a superblock on the whole device.
> This is one of the shortcomings of v0.90 superblocks.  v1.0 doesn't
> have this problem.
>
> >
> > How can I clear these? If I unmount my raid, stop md0, it won't clear it.
>
> mdadm --zero-superblock device name
>
> is the best way to remove an unwanted superblock.  Ofcourse in the
> above described case, removing the unwanted superblock will remove the
> wanted one aswell.
>
>
> >
> > [root@zeus ~]# mdadm --zero-superblock /dev/hdd
> > mdadm: Couldn't open /dev/hdd for write - not zeroing
>
> As I think someone else pointed out "/dev/hdd" is not "/dev/sdd".
>
> NeilBrown
>
