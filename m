From: "Norman Elton" <normelton@gmail.com>
Subject: Re: Raid over 48 disks ... for real now
Date: Fri, 18 Jan 2008 13:44:29 -0500
Message-ID: <6b3a7f010801181044w209007b5wa4eec3a4af680fea@mail.gmail.com>
References: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
	 <20080118080849.9cidbh0so4wkkc44@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080118080849.9cidbh0so4wkkc44@estone.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is quite a box. There's a picture of the box with the cover removed
on Sun's website:

http://www.sun.com/images/k3/k3_sunfirex4500_4.jpg

From the X4500 homepage, there's a gallery of additional pictures. The
drives drop in from the top. Massive fans channel air in the small
gaps between the drives. It doesn't look like there's much room
between the disks, but a lot of cold air gets sucked in the front, and
a lot of hot air comes out the back. So it must be doing its job :).

I have not tried a fsck on it yet. I'll probably setup a lot of 2TB
partitions rather than a single large partition. Then write the
software to handle storing data across many partitions.

Norman

On 1/18/08, michael@estone.ca <michael@estone.ca> wrote:
> Quoting Norman Elton <normelton@gmail.com>:
>
> > I posed the question a few weeks ago about how to best accommodate
> > software RAID over an array of 48 disks (a Sun X4500 server, a.k.a.
> > Thumper). I appreciate all the suggestions.
> >
> > Well, the hardware is here. It is indeed six Marvell 88SX6081 SATA
> > controllers, each with eight 1TB drives, for a total raw storage of
> > 48TB. I must admit, it's quite impressive. And loud. More information
> > about the hardware is available online...
> >
> > http://www.sun.com/servers/x64/x4500/arch-wp.pdf
> >
> > It came loaded with Solaris, configured with ZFS. Things seemed to
> > work fine. I did not do any benchmarks, but I can revert to that
> > configuration if necessary.
> >
> > Now I've loaded RHEL onto the box. For a first-shot, I've created one
> > RAID-5 array (+ 1 spare) on each of the controllers, then used LVM to
> > create a VolGroup across the arrays.
> >
> > So now I'm trying to figure out what to do with this space. So far,
> > I've tested mke2fs on a 1TB and a 5TB LogVol.
> >
> > I wish RHEL would support XFS/ZFS, but for now, I'm stuck with ext3.
> > Am I better off sticking with relatively small partitions (2-5 TB), or
> > should I crank up the block size and go for one big partition?
>
> Impressive system. I'm curious to what the storage drives look like
> and how they attach to the server with that many disks?
> Sounds like you have some time to play around before shoving it into
> production.
> I wonder how long it would take to run an fsck on one large filesystem?
>
> Cheers,
> Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
