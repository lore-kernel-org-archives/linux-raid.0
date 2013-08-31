From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: Is a raid0 512 byte chunk size possible? Or is it just too small?
Date: Fri, 30 Aug 2013 18:58:50 -0600
Message-ID: <CALFpzo7sZgjrZbfT=1uT3UMWwA7TG6pBXsj4f+oxRAfwuvWZ9w@mail.gmail.com>
References: <CANb3qHcczcKrCOPWy7MfY2aP_0V2c5KkQa6zzm5f1J7Qx20W8w@mail.gmail.com>
	<52210FAB.7060606@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52210FAB.7060606@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Veedar Hokstadt <veedar@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maybe he has raw drives that were in this NAS and is trying to match
the layout to recover something? I know that's probably not going to
work, certainly without a lot of other things going right, but its the
first thing that came to mind, given his reasoning and how he stated
it.

On Aug 30, 2013 3:36 PM, "Stan Hoeppner" <stan@hardwarefreak.com> wrote:
>
> On 8/30/2013 2:32 PM, Veedar Hokstadt wrote:
> > Hello,
> > I would like to use mdadm to set up a raid0 with a 512B chunk size.
> >
> > I ask as my purpose is to mimic a raid0 config from a Lacie NAS box
> > that uses a 512B chunk size.
>
> Your reasoning is flawed.  Why would you want to imitate a configuration
> that is inherently flawed?
>
> > The lowest chunk value mdadm will accpet is 4. Anything less and mdadm
> > gives an error "invalid chunk/rounding value"
>
> For good reason.
>
> > Is there any way to create a raid0 with a 512B chunk?
>
> First, if you're using RAID0 it absolutely must be assumed that you
> desire maximum speed, care nothing for redundancy, and you don't care if
> you lose your data when a disk fails because you have a full backup of
> the RAID0 filesystem.
>
> If you want speed, using RAID0 with a 512 byte chunk isn't going to
> achieve it.  On the contrary, using such a small chunk will drop a
> hammer on your throughput because you're processing a much larger number
> of IOs per quantity of data transferred.  This is extremely inefficient,
> and throughput drops.  With RAID0 you typically want a very large chunk,
> the largest your drives can ingest efficiently in a single IO.  I'll
> make an educated assumption that you plan to store media files on this
> array, probably DVDs/CDs, and/or use it as a DVR.  In this case you want
> a large chunk, 512KB-1MB.
>
> However, you've stated you want to duplicate a NAS device.  Consider
> that GbE using Rtl 81xx devices tops out at ~70-90 MBs application level
> throughput.  Two modern drives in RAID0 with a proper chunk size can
> read/write at double that rate.  Given this fact, why are you bothering
> with RAID0?  You won't see any of the increased performance RAID0 can
> give you.  In fact a single modern drive can saturate GbE.
>
> I assume you are using RAID0 simply as an inexpensive way to maximize
> your storage capacity.  That's fine with backups or if you have the
> original media.  If you don't, or don't want to go through the hassle of
> recreating your RAID0 after a disk failure and replacement, and copying
> all your files back to it, I suggest you use RAID1/5/6/10 instead.
>
> --
> Stan
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
