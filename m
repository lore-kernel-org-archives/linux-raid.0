From: "Don Dupuis" <dondster@gmail.com>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Mon, 21 May 2007 21:47:13 -0500
Message-ID: <632b79000705211947k471cc6fdr76dc74f334b8112c@mail.gmail.com>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	 <17995.46536.195175.894763@notabene.brown>
	 <632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	 <632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
	 <632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
	 <632b79000705211232gfb57e0focae8cdd0bf25bef@mail.gmail.com>
	 <18002.15951.765872.809204@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18002.15951.765872.809204@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/21/07, Neil Brown <neilb@suse.de> wrote:
> On Monday May 21, dondster@gmail.com wrote:
> > On 5/16/07, Don Dupuis <dondster@gmail.com> wrote:
> > >
> > > I am still trying to get where I had the low recover rate with the
> > > bitmap turned on. I will get back with you
> > > Don
> > >
> > Any new updates Neil?
> > Any new things to try to get you additional info?
> > THanks
> >
> > Don
>
> You said "I will get back with you" and I was waiting for that... I
> hoped that your further testing might reveal some details that would
> shine a light on the situation.
>
> One question:  Your description seems to say that you get corruption
> after the resync has finished.  Is the corruption there before the
> resync starts?
> I guess what I would like it:
>   Start with fully active array.  Check for corruption.
>   Remove one drive.  Check for corruptions.
>   Turn off system.  Turn it on again, array assembles with one
>   missing device.  Check for corruption.
>   Add device, resync starts.  Check for corruption.
>   Wait for resync to finish.  Check for corruption.
>
> NeilBrown
>
I was going to get back with you concerning the low resync rates. The
data corruption happens like this.
1.  Start with fully active array. Everything is fine.
2.  I remove a drive. Everything is fine. I then will power off the machine.
3.  I powerup and load up an initramfs which has my initial root
filesystem and scripts for handling the assembly of the array. My init
script will determine which drive was remove and assemble the
remaining 3. If a resync happens, I will wait for the resync to
complete. If complete I will then do a fdisk -l /dev/md_d0 to make
sure the partition table is complete. Most of the time, it will be
"unknow partition table. At this point I am dead in the water because
I can't pivot_root to my real root filesystem. If I get through the
resync and the partition table is correct my other corruption will be
to filesystems on the md device. All filesystems are ext3 with full
data journaling enabled. I could have one corrupted or multiple. fsck
will not be able to clean up. Under normal circumstances, once I am up
running on the real root filesystem I would add the removed disk back
into the md device with the recover running in the back ground. Sorry
for the confusion on the "get back with you". I basically have 2
issues, the corruption issue is my main priority at this point.

Thanks

Don
