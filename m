From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Thu, 15 May 2014 09:04:27 +0200
Message-ID: <CAAOsTSmvGOwhmFW4PRfkmVnSApNKrsZfa6RAbjEhwQh-+ko1vQ@mail.gmail.com>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
	<20120528113145.1b8ac4ab@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120528113145.1b8ac4ab@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

did you make some progress on this issue by any chance?

I am hitting the same problem again on degraded RAID 6 missing two
drives, kernel Debian 3.13.10-1, mdadm v3.2.5.

Thanks.

Patrik

2012-05-28 3:31 GMT+02:00 NeilBrown <neilb@suse.de>:
>
> On Thu, 24 May 2012 14:37:28 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
> > On Thu, May 24, 2012 at 6:48 AM, NeilBrown <neilb@suse.de> wrote:
>
> > > Firstly, degraded RAID6 with a left-symmetric layout is quite dif=
ferent from
> > > an optimal RAID5 because there are Q blocks sprinkled around and =
some D
> > > blocks missing.  So there will always be more work to do.
> > >
> > > Degraded left-symmetric-6 is quite similar to optimal RAID5 as th=
e same data
> > > is stored in the same place - so reading should be exactly the sa=
me.
> > > However writing is generally different and the code doesn't make =
any attempt
> > > to notice and optimise cases that happen to be similar to RAID5.
> >
> > Actually I have left-symmetric-6 without one of the "regular" drive=
s
> > not the one with only Qs on it, so it should be similar to degraded
> > RAID6 with a left-symmetric in this regard.
>
> Yes, it should - I had assumed wrongly ;-)
>
> >
> > > A particular issue is that while RAID5 does read-modify-write whe=
n updating a
> > > single block in an array with 5 or more devices (i.e. it reads th=
e old data
> > > block and the parity block, subtracts the old from parity and add=
s the new,
> > > then writes both back), RAID6 does not. It always does a reconstr=
uct-write,
> > > so on a 6-device RAID6 it will read the other 4 data blocks, comp=
ute P and Q,
> > > and write them out with the new data.
> > > If it did read-modify-write it might be able to get away with rea=
ding just P,
> > > Q, and the old data block - 3 reads instead of 4.  However subtra=
cting from
> > > the Q block is more complicated that subtracting from the P block=
 and has not
> > > been implemented.
> >
> > OK, I did not know that. In my case I have 8 drives RAID6 degraded =
to
> > 7 drives, so it would be plus to have it implemented the RAID5 way.
> > But anyway I was thinking the whole-stripe detection should work in
> > this case.
> >
> > > But that might not be the issue you are hitting - it simply shows=
 that RAID6
> > > is different from RAID5 in important but non-obvious ways.
> > >
> > > Yes, RAID5 and RAID6 do try to detect whole-stripe write and writ=
e them out
> > > without reading.  This is not always possible though.
> > > Maybe if you told us how many devices were in your arrays (which =
may be
> > > import to understand exactly what is happening), what the chunk s=
ize is, and
> > > exactly what command you use to write "lots of data".  That might=
 help
> > > understand what is happening.
> >
> > The RAID5 is 5 drives, the RAID6 arrays are 7 of 8 drives, chunk si=
ze
> > is 64K. I am using command dd if=3D/dev/zero of=3Dfile bs=3DX count=
=3DY, it
> > behaves the same for bs between 64K to 1 MB. Actually internal read
> > speed from every drive is slightly higher that write speed, about c=
ca
> > 10%. The ratio between write speed to the array and write speed to
> > individual drive is cca 5.5 - 5.7.
>
> I cannot really picture how the read speed can be higher than the wri=
te
> speed.  The spindle doesn't speed up for reads and slow down for writ=
es does
> it?  But that's not really relevant.
>
> A 'dd' with large block size should be a good test.  I just did a sim=
ple
> experiment.  With a 4-drive non-degraded RAID6 I get about a 1:100 ra=
tio for
> reads to writes for an extended write to the filesystem.
> If I fail one device it becomes 1:1.  Something certainly seems wrong=
 there.
>
> RAID5 behaves more as you would expect - many more writes than reads.
>
> I've made a note to look into this when I get a chance.
>
> Thanks for the report.
>
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
