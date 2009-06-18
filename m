From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Resize Raid5 devices
Date: Thu, 18 Jun 2009 10:27:22 +0200
Message-ID: <87tz2e7xqt.fsf@frosties.localdomain>
References: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62E07ACC-0F47-4B5F-94C7-29199ECE46FE@bj-ig.de> (Ralf Mueller's
	message of "Wed, 17 Jun 2009 16:22:20 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Ralf Mueller <ralf@bj-ig.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ralf M=FCller <ralf@bj-ig.de> writes:

> After I added a forth 1.5TB disk to the array yesterday and reshaped =
the
> former 3 disk raid5 to a 4 disk one, I wiped out the 300GB disk raid5=
,
> set one
> of the 1.2TB partitions faulty, removed it from its raid, removed the
> 300GB
> partition and resized the former 1.2TB partition (in place) to
> 1.5TB. Now I
> added this partition to its raid.
>
> It has been recognized as a former member of this raid - so far so
> good - but
> for whatever reason the raid subsystem decided to start a complete
> recovery.
> So here my question:
>
> What went wrong and what do I have to do to avoid a full recovery for
> the
> next disk?

I guess something wrote to your raid5 while the one disk was
removed. When you added it back the event counter would differ and the
disk needs to be resynced completly. A bitmap would help limiting this
to the parts that have changed. Add an internal bitmap before you
remove the next disk.

Alternatively stop the raid completly, resize all the partitions and
start the raid again. No need to fail/readd each disk in turn.

> I do not feel well with a degraded raid5 in a 10 hour rebuild ...
>
> Regards
> Ralf

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
