From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Life's too short ...(Raid 1 sync times)
Date: Sun, 29 Feb 2004 22:29:59 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xr7wd1smg.fsf@kth.se>
References: <40423D29.1050401@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie <richard@sauce.co.nz> writes:

> I am in the process of benchmarking a 4 x 250GB on 3ware 7506 to try =
and
> sort out the myriad of options for RAID and XFS, in order to get best
> performance for my workload.
>
> I have tested with software RAID5 and have just attempted to do the s=
ame
> for software RAID 10. Unfortunately, it is going to take 31000 minute=
s,
> or around 21 days to sync this array and I wish to test 3 different
> stripe sizes. Is there some way to allow more bandwidth for the sync =
up?

echo 200000 > /proc/sys/dev/raid/speed_limit_min

It's a known bug.  The resync code is trying to be nice to other IO in
the system, but forgets that it is itself causing lots of IO in the
lower RAID layer.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
