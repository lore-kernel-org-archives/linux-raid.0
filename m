From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 10:37:40 +0530
Message-ID: <37d33d830905122207pd676f00vac502f18d972dfae@mail.gmail.com>
References: <4A060CBE.9090308@tmr.com>
	 <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	 <18954.19719.172893.761454@notabene.brown>
	 <37d33d830905122137l18f13c2aoec8e1cf67fdba2c0@mail.gmail.com>
	 <18954.21141.982191.727975@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.21141.982191.727975@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, May 13, 2009 at 10:24 AM, Neil Brown <neilb@suse.de> wrote:
> On Wednesday May 13, sandeepksinha@gmail.com wrote:
>> Hi,
>>
>> On Wed, May 13, 2009 at 10:01 AM, Neil Brown <neilb@suse.de> wrote:
>> > On Tuesday May 12, lrhorer@satx.rr.com wrote:
>> >>
>> >> But doesn't creating the array with the drive wipe the contents? =
=A0If so, it
>> >> doesn't seem to me this provides much redundancy.
>> >
>> > No. =A0Creating an array does not wipe the contents.
>> > It might cause a resync which will copy contents from one drive to=
 the
>> > other and I don't promise which one.
>> > However if you:
>> >
>> Now, my question is that what if I create a RAID1 with 100 disks on =
each side.
>> Do you mean to say that there will be unnecessary resync happening
>> there as well, that too for unallocated/written data.
>
> I'm not sure what "100 disks on each side" means.
> Do you mean a raid1 across 100 devices? =A0i.e. 100 copies of each
> block?
>

I meant we have two copies of 100 disks on each side of the mirror.
Sorry, I am not very sure how md would handle it but say, I created
two logical volumes of 100 disks and try to make a raid1 out of it.

> In any case, md has no concept of unallocated/written data. =A0Every
> block is potentially meaningful and needs to be copied for resync.
>

So, while creation it is always guaranteed that a resync will always
happen. I believe this can be avoided by just adding some flags. The
user can specify its intention.

> I have had thoughts about keeping track of which blocks have been use=
d
> so that 'TRIM' can be passed down. =A0But it is a long way from being=
 a
> reality.
>
>
>>
>> If thats the case, we surely need to handle these two situations
>> differently (1) which neil mentioned (2) the one I mentioned above.
>>
>> Remember I referring to the case of creation.
>>
>> > =A0 mdadm -C /dev/md0 --level 1 -n 2 /dev/foo missing
>> > =A0 mdadm /dev/md0 --add /dev/bar
>> >
>> > then the contents on /dev/foo will not be changed (except for a fe=
w K
>> > at the end for the metadata) and then all of foo will be copied to
>> > bar.
>> >
>>
>> Will the create happen at the first place?
>
> I don't understand this question, sorry.
>
Actually I could not understand, what did you mean by "missing" in the
above line, which creates the array.

> NeilBrown
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
