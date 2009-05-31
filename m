From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RAID5 reconstruction ?
Date: Sun, 31 May 2009 13:32:03 +0530
Message-ID: <37d33d830905310102m451f26aaw8e233227cda491c@mail.gmail.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>
	 <4A213612.7080206@anonymous.org.uk>
	 <1243699735.5740.103.camel@localhost>
	 <878wkezagw.fsf@frosties.localdomain>
	 <1243712247.5740.105.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243712247.5740.105.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 31, 2009 at 1:07 AM, Redeeman <redeeman@metanurb.dk> wrote:
> On Sat, 2009-05-30 at 20:55 +0200, Goswin von Brederlow wrote:
>> Redeeman <redeeman@metanurb.dk> writes:
>>
>> > On Sat, 2009-05-30 at 14:35 +0100, John Robinson wrote:
>> >> On 30/05/2009 06:44, SandeepKsinha wrote:
>> >> > Hi all,
>> >> >
>> >> > Say If I have a RAID 5 array of 50GB of five disks of 10GB each=
=2E
>> >> >
>> >> > I have data of 5GB. When a disk fails and replaced with a spare=
 disk.
>> >> > Will the reconstruction happen only for the 5GB allocated disk =
blocks
>> >> > or it will happen for the whole disk size.
>> >>
>> >> The whole disc size, for now anyway; md does not currently note w=
hich
>> >> blocks have been used by its client (the filesystem, LVM, whateve=
r).
>> >>
>> >> > Is it possible to make =A0reconstruction intelligent enough to =
keep it optimized ?
>> >>
>> >> This has been discussed in combination with supporting SSD drives=
' TRIM
>> >> function, and would mean md had to keep track of used chunks or p=
ossibly
>> >> even sectors using a bitmap or something like that, but whether a=
nyone's
>> >> working on it I don't know.
>> >
>> > I would say it should be possible to 'query' the filesystem for th=
at
>> > information. Obviously this will only work if you run a filesystem=
 on it
>> > which supports it, but it would seem like a nicer solution than a =
bitmap
>> > for it.
>> >
>> >>
>> >> Cheers,
>> >>
>> >> John.
>>
>> And just when I hit send I thought of something else.
>>
>> Instead of the initial sync when creating a raid the bitmap could ju=
st
>> mark all blocks as unused. Much faster raid creation.
>


This really sounds like a good option. This would have a slight hit
for writes which I believe will compensate for later re-constructions,
replacing a disk, mirror resysnc and many more operation.

Neil any comments on this?

I mean, how difficult would it be to maintain such a bitmap. This can
though of making something optional as this will incur space.


> A filesystem-coexist mode could also do this, by simply refusing
> operation until such a time that a filesystem is detected, or i suppo=
se
> in worst case, mounted...


>
>>
>> MfG
>> =A0 =A0 =A0 =A0 Goswin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
