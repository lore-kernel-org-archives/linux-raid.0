From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: Re: Basic RAID5/6 reshape question
Date: Thu, 11 Dec 2008 20:06:16 -0500
Message-ID: <7d86ddb90812111706t14e7fbdar6bf31a22d510a6b6@mail.gmail.com>
References: <4940E377.7070907@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4940E377.7070907@wasp.net.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It takes 3 hours to resync my 3 x 1 TB drive RAID 5 array at a rate of
85MB/s. It shouldn't take 20 hours to write 3 x 1 TB drives. How fast
is it progressing? You might consider a PCI-X or PCI Express SATA or
SAS controller card. I have my drives connected to an Supermicro LSI
1068 PCI Express SAS card, which performs great.

The other option would be to create 2 RAID 5 arrays of 5 drives each.
Create the first array and use LVM with the filesystem of your choice.
Add the second array later and expand the LVM volume.

Ryan

On Thu, Dec 11, 2008 at 4:55 AM, Brad Campbell <brad@wasp.net.au> wrote:
> G'day all,
>
> I'm just doing some system upgrades and shuffling some arrays around as part
> of the process.
> All my other current questions have been answered by experimentation, but
> one.
>
> I'm going to start with a RAID 6 comprised of 7 x 1TB drives, and reshaping
> to 10 x 1TB.
> I'm doing an experiment right now with re-shaping a RAID-5 of 2 drives into
> 3 drives which is taking about 20 hours, from that I'm assuming that a nice
> big re-shape will take a considerable amount of time. I have a reliable UPS,
> I'm more concerned about a drive or cable flaking out.
>
> What happens if I'm in the middle of a reshape of a RAID 5 or 6 and lose a
> drive?
>
> Will the array be able to continue to reshape in a degraded state?
>
> Hoping of course that this does not occur, but just trying to plan ahead in
> case.
>
> Regards,
> Brad
> --
> Dolphins are so intelligent that within a few weeks they can
> train Americans to stand at the edge of the pool and throw them
> fish.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
