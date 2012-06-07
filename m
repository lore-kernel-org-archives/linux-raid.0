From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Thu, 07 Jun 2012 04:03:20 -0500
Message-ID: <4FD06E58.6060509@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+4vN7xQgecd95FO6gYVLMuPDKXbfZfzuXS1dzHd+e-otrPxwg@mail.gmail.com> <CA+sTkh5m9vumG=56n024jBFobaozOQQJjesh=Cc--C7J0FCnfg@mail.gmail.com> <CA+4vN7xWST=vgMpd9s0Q0MGmPQq1Fe=FZkSc_qPEfX0vOQskoA@mail.gmail.com> <CA+sTkh6xUbQGLXpNiUHmHZoqPaQUrGgoyyX1EssjpO8g8hVZNQ@mail.gmail.com> <20431.57247.76819.834529@tree.ty.sabi.co.UK> <CA+sTkh6=Kn1EJ79zCxWW6Xr-H23E+-HpqJVD33vP4rJMQ3ON4g@mail.gmail.com> <4FD0353C.1050006@hardwarefreak.com> <CA+sTkh4-3wawWBEiGtzNuMvdyv8uP6Jrh22JDhTP+mu7vDW7nw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh4-3wawWBEiGtzNuMvdyv8uP6Jrh22JDhTP+mu7vDW7nw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: Peter Grandi <pg@lxra2.to.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/7/2012 12:22 AM, Igor M Podlesny wrote:
> On 7 June 2012 12:59, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 6/6/2012 10:41 PM, Igor M Podlesny wrote:
>>>    They try, for sure, but try is still a try. For e. g., you pvmov=
e'd
>>> your LVM with XFS from one RAID to another one having different
>>> "layout", things can just stop working well all of the sudden.
>>
>> Filesystems that have zero awareness of the storage geometry have po=
or
>> performance on striped RAID devices.  XFS has excellent performance =
on
>> striped RAID specifically due to this awareness.  Now you describe t=
his
>=20
>    And Btrfs is way faster (~ 30 %) on single sustained 22 GiB readin=
g
> =97 http://poige.livejournal.com/560643.html

I don't see anything there that credibly demonstrates what you state
here.  Also note this is an English only mailing list.  Linking to a
forum that is primarily in Russian, I assume, and where half the posts
are by you, doesn't lend any credibility to your arguments.

>    XFS is excellent but for parallel I/O mainly due to its multiple
> allocation groups, not "RAID awareness"=20

With storage geometries more complex than a single RAID array, which is
probably more common with XFS than not, allocation groups are then
designed around the storage geometry.  Thus these two things are equall=
y
important to the overall performance of the filesystem, especially with
high IOPS metadata heavy workloads.  So yes, storage geometry awareness
plays a very large role in overall performance.  I don't have the time
to post an example scenario at the moment.  You can see examples in
previous posts of mine relating to maildir performance.

> =97 EXT3/4 can be formatted
> adjusted to RAID's layout just as XFS, in case you didn't know it.

Yes, EXT can be informed of the geometry on the command line.  I freely
admit I don't keep up with EXT development, but last I recall mke2fs
didn't query md and populate its stripe parameters automatically.  XFS
has for quite some time.  I always do mine manually anyway, so automati=
c
stuff really doesn't matter to me.  Just pointing out a difference, if
it still exists.

>> strength as a weakness due to a volume portability corner case no SA=
 in
>> his right mind would attempt.
>>
>> The proper way to do this is to perform an xfsdump of the filesystem=
 to
>> a file, create a new XFS with the proper stripe geometry in the new
>> storage location (which takes all of 1 second BTW), then xfsrestore =
the
>> dump file.
>=20
>    Damn the proper way, Stan, if it's inconvenient one, and some
> better results can be automagically achieved using another way. Which
> one is more proper then? )

It depends on how much one values his data integrity and performance,
and what one considers "inconvenient".  If it takes 3 hours to move a
large filesystem to another array with your pvmove method and you end u=
p
with performance problems afterward, what's the real human time
difference if it takes 5 hours to do it correctly with xfsdump/restore
and an mkfs.xfs?

BTW, if you use an aligned EXT4, you have the same problem with the new
RAID geometry.  But EXT4 doesn't have integrated dump/restore
facilities, so you'd have to use something like tar, which will take
many times longer due to all the system calls.  xfsdump/restore send
commands directly to the filesystem driver--no user space calls.

>    I see no point in arguing just to argue.

Accepting the fact there are people on this list who have far more
knowledge of XFS internals than yourself would be a good start.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
