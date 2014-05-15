From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: Re: Sequential writing to degraded RAID6 causing a lot of reading
Date: Thu, 15 May 2014 09:50:49 +0200
Message-ID: <CAAOsTSnk+_HfrHK2WVjDVXiNjB2PTzp+8L6a5McJ80TzE=KOyg@mail.gmail.com>
References: <CAAOsTSmnbtejYvjoMpdOzrGFM0+PW45uuf-uBNkR4HUkgyaWDg@mail.gmail.com>
	<20120524144822.747b446b@notabene.brown>
	<CAAOsTSm47hy6YF-5fodB+2G6n1E=+Ces_PWsSo7F6GKEF_R1iA@mail.gmail.com>
	<20120528113145.1b8ac4ab@notabene.brown>
	<CAAOsTSmvGOwhmFW4PRfkmVnSApNKrsZfa6RAbjEhwQh-+ko1vQ@mail.gmail.com>
	<20140515171853.4cdfddd0@notabene.brown>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140515171853.4cdfddd0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK, it seems that because of that my copy operations will not be
finished yet by next week... :)

BTW this time layout is left-symetric but the problem I guess is in
whole strip' write detection with degraded RAID6.

Patrik

2014-05-15 9:18 GMT+02:00 NeilBrown <neilb@suse.de>:
> On Thu, 15 May 2014 09:04:27 +0200 Patrik Horn=EDk <patrik@dsl.sk> wr=
ote:
>
>> Hello Neil,
>>
>> did you make some progress on this issue by any chance?
>
> No I haven't - sorry.
> After 2 year, I guess I really should.
>
> I'll make another note for first thing next week.
>
> NeilBrown
>
>
>>
>> I am hitting the same problem again on degraded RAID 6 missing two
>> drives, kernel Debian 3.13.10-1, mdadm v3.2.5.
>>
>> Thanks.
>>
>> Patrik
>>
>> 2012-05-28 3:31 GMT+02:00 NeilBrown <neilb@suse.de>:
>> >
>> > On Thu, 24 May 2012 14:37:28 +0200 Patrik Horn=EDk <patrik@dsl.sk>=
 wrote:
>> >
>> > > On Thu, May 24, 2012 at 6:48 AM, NeilBrown <neilb@suse.de> wrote=
:
>> >
>> > > > Firstly, degraded RAID6 with a left-symmetric layout is quite =
different from
>> > > > an optimal RAID5 because there are Q blocks sprinkled around a=
nd some D
>> > > > blocks missing.  So there will always be more work to do.
>> > > >
>> > > > Degraded left-symmetric-6 is quite similar to optimal RAID5 as=
 the same data
>> > > > is stored in the same place - so reading should be exactly the=
 same.
>> > > > However writing is generally different and the code doesn't ma=
ke any attempt
>> > > > to notice and optimise cases that happen to be similar to RAID=
5.
>> > >
>> > > Actually I have left-symmetric-6 without one of the "regular" dr=
ives
>> > > not the one with only Qs on it, so it should be similar to degra=
ded
>> > > RAID6 with a left-symmetric in this regard.
>> >
>> > Yes, it should - I had assumed wrongly ;-)
>> >
>> > >
>> > > > A particular issue is that while RAID5 does read-modify-write =
when updating a
>> > > > single block in an array with 5 or more devices (i.e. it reads=
 the old data
>> > > > block and the parity block, subtracts the old from parity and =
adds the new,
>> > > > then writes both back), RAID6 does not. It always does a recon=
struct-write,
>> > > > so on a 6-device RAID6 it will read the other 4 data blocks, c=
ompute P and Q,
>> > > > and write them out with the new data.
>> > > > If it did read-modify-write it might be able to get away with =
reading just P,
>> > > > Q, and the old data block - 3 reads instead of 4.  However sub=
tracting from
>> > > > the Q block is more complicated that subtracting from the P bl=
ock and has not
>> > > > been implemented.
>> > >
>> > > OK, I did not know that. In my case I have 8 drives RAID6 degrad=
ed to
>> > > 7 drives, so it would be plus to have it implemented the RAID5 w=
ay.
>> > > But anyway I was thinking the whole-stripe detection should work=
 in
>> > > this case.
>> > >
>> > > > But that might not be the issue you are hitting - it simply sh=
ows that RAID6
>> > > > is different from RAID5 in important but non-obvious ways.
>> > > >
>> > > > Yes, RAID5 and RAID6 do try to detect whole-stripe write and w=
rite them out
>> > > > without reading.  This is not always possible though.
>> > > > Maybe if you told us how many devices were in your arrays (whi=
ch may be
>> > > > import to understand exactly what is happening), what the chun=
k size is, and
>> > > > exactly what command you use to write "lots of data".  That mi=
ght help
>> > > > understand what is happening.
>> > >
>> > > The RAID5 is 5 drives, the RAID6 arrays are 7 of 8 drives, chunk=
 size
>> > > is 64K. I am using command dd if=3D/dev/zero of=3Dfile bs=3DX co=
unt=3DY, it
>> > > behaves the same for bs between 64K to 1 MB. Actually internal r=
ead
>> > > speed from every drive is slightly higher that write speed, abou=
t cca
>> > > 10%. The ratio between write speed to the array and write speed =
to
>> > > individual drive is cca 5.5 - 5.7.
>> >
>> > I cannot really picture how the read speed can be higher than the =
write
>> > speed.  The spindle doesn't speed up for reads and slow down for w=
rites does
>> > it?  But that's not really relevant.
>> >
>> > A 'dd' with large block size should be a good test.  I just did a =
simple
>> > experiment.  With a 4-drive non-degraded RAID6 I get about a 1:100=
 ratio for
>> > reads to writes for an extended write to the filesystem.
>> > If I fail one device it becomes 1:1.  Something certainly seems wr=
ong there.
>> >
>> > RAID5 behaves more as you would expect - many more writes than rea=
ds.
>> >
>> > I've made a note to look into this when I get a chance.
>> >
>> > Thanks for the report.
>> >
>> > NeilBrown
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
