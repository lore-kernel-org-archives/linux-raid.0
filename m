From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: Change Chunk Size on Array?
Date: Wed, 13 May 2009 10:23:35 +0530
Message-ID: <37d33d830905122153j5c38cddby616863e026cd241e@mail.gmail.com>
References: <16137381.post@talk.nabble.com> <23514897.post@talk.nabble.com>
	 <18954.20603.952706.467047@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.20603.952706.467047@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 13, 2009 at 10:15 AM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday May 12, sandeepksinha@gmail.com wrote:
>>
>>
>>
>> crshman wrote:
>> >
>> > Hello All,
>> >
>> > I wanted to know if it were possible to change the chunk size on a=
n array
>> > after it has been created. I have a software raid 5 comprised of 7=
 drives
>> > with a chunk size of 64k. I wanted to up that to 1024k, would this=
 be
>> > possible without losing any data? This isn't mission critical so i=
t is ok
>> > if i need to stop the array first, however I'd rather not lose any=
 data.
>> >
>> It is possible to change the chunksize but for the same you would ne=
ed to
>> offline your array.
>
> Is it? =A0How?
>

That was all that I could read from" RAID on Linux" by Derek Vadala, Pa=
ge 118.

It mentions that this could be achieved by offlining the array and
using "raidreconf".
He also mention chances of data loss and also the caveats of "raidrecon=
f".


> Online changing of chunk size for raid5 is very close to being
> implemented.
> All the kernel side support will be in 2.6.30.
> I just need to spend some time getting mdadm to make it work.
> Because data is being rearranged in-place, and because you don't want
> to lose everything if your systems crashes, mdadm will have to work i=
n
> tandem with the kernel making a backup copy of a section of the array=
,
> allowing the kernel to reshape that section, and then moving on to th=
e
> next section. =A0It will be slow, but it will be reliable.
>
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
