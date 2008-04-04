From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: performance problems with raid10,f2
Date: Fri, 4 Apr 2008 10:03:59 +0200
Message-ID: <20080404080359.GA5264@rap.rap.dk>
References: <20080314231151.GA14568@rap.rap.dk> <20080320172817.GA27070@rap.rap.dk> <18408.35320.92714.891870@notabene.brown> <20080325103656.GA4911@rap.rap.dk> <18408.64635.201923.65782@tree.ty.sabi.co.uk> <20080402211315.GA7899@rap.rap.dk> <18421.15381.649822.295786@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18421.15381.649822.295786@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 03, 2008 at 09:20:37PM +0100, Peter Grandi wrote:
> >>> On Wed, 2 Apr 2008 23:13:15 +0200, Keld J=F8rn Simonsen
> >>> <keld@dkuug.dk> said:
>=20
> [ ... slow RAID reading ... ]
>=20
> >> That could be the usual issue with apparent pauses in the
> >> stream of IO requests to the array component devices, with
> >> the usual workaround of trying 'blockdev --setra 65536
> >> /dev/mdN' and see if sequential reads improve.
>=20
> keld> Yes, that did it!=20
>=20
> But that's as usual very wrong. Such a large readhead has
> negative consequences, and most likely is the result of both
> some terrible misdesign in the Linux block IO subsystem (from
> some further experiments it is most likely related to "plugging")
> and integration of MD into it.
>=20
> However I have found that on relatively fast machines (I think)
> much lower values of read-ahead still give reasonable speed,
> with some values being much better than others. For example with
> another RAID10 I get pretty decent speed with a read-ahead of
> 128 on '/dev/md0' (but much worse with say 64 or 256). On others
> 1000 sectors read-ahead is good.
>=20
> The read-ahead needed also depends a bit on the file system
> type, don't trust tests done on the block device itself.
>=20
> So please experiment a bit to try and reduce it, at least until
> I find the time to figure out the (surely embarrasing) reason
> why it is needed and how to avoid it, or the Linux block IO and
> MD maintainers confess (they almost surely already know why)
> and/or fix it already.

I did experiment and I noted that a 16 MiB readahead was sufficient.

And then I was wondering if this had negative consequences, eg on rando=
m
reads.

I then had a test with reading 1000 files concurrently, and Some strang=
e
things happened. Each drive was doing about 2000 transactions per
second  (tps). Why? I thought a drive could only do about 150 tps, give=
n
t5hat it is a 7200 rpm drive.=20

What is tps measuring?

Why is the fs not reading the chunk size for every IO operation?

Best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
