From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Awful RAID5 random read performance
Date: Sat, 06 Jun 2009 19:06:01 -0400
Message-ID: <4A2AF659.3090304@tmr.com>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com>	<200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com>	<20090602194704.GA30639@rap.rap.dk>	<4A25B201.2000705@anonymous.org.uk> <4A26C313.6080700@tmr.com>	<4A26D5AE.2000003@anonymous.org.uk> <878wk9q7qp.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878wk9q7qp.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> John Robinson <john.robinson@anonymous.org.uk> writes:
>
>  =20
>> On 03/06/2009 19:38, Bill Davidsen wrote:
>>    =20
>>> John Robinson wrote:
>>>      =20
>>>> On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
>>>>        =20
>> [...]
>>    =20
>>>>> In your case, using 3 disks, raid5 should give about 210 % of the
>>>>> nominal
>>>>> single disk speed for big file reads, and maybe 180 % for big fil=
e
>>>>> writes. raid10,f2 should give about 290 % for big file reads and =
140%
>>>>> for big file writes. Random reads should be about the same for ra=
id5 and
>>>>> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes shou=
ld be
>>>>> mediocre for raid5, and good for raid10,f2.
>>>>>          =20
>>>> I'd be interested in reading about where you got these figures fro=
m
>>>> and/or the rationale behind them; I'd have guessed differently...
>>>>        =20
>>> For small values of N, 10,f2 generally comes quite close to N*Sr,
>>> where N is # of disks and Sr is single drive read speed. This is
>>> assuming fiarly large reads and adequate stripe buffer
>>> space. Obviously for larger values of N that saturates something
>>> else in the system, like the bus, before N gets too large. I don't
>>> generally see more than (N/2-1)*Sw for write, at least for large
>>> writes. I came up with those numbers based on testing 3-4-5 drive
>>> arrays which do large file transfers. If you want to read more than
>>> large file speed into them, feel free.
>>>      =20
>
> With far copies reading is like reading raid0 and writing is like
> raid0 but writing twice with a seek between each. So (N/2) and (N/2-a
> bit) are the theoretical maximums and raid10 comes damn close to thos=
e.
>
>  =20
>> Actually it was the RAID-5 figures I'd have guessed differently. I'd
>> expect ~290% (rather than 210%) for big 3-disc RAID-5 reads, and ~14=
0%
>> (rather than "mediocre") for random small writes. But of course I
>> haven't tested.
>>    =20
>
> That kind of depends on the chunk size I think.
>
> Say you have a raid 5 with chunk size << size of 1 track. Then on eac=
h
> disk you read 2 chunks, skip a chunk, read 2 chunks, skip a chunk. Bu=
t
> skipping a chunk means waiting for the disk to rotate over it. That
> takes as long as reading it. You shouldn't even get 210% speed.
>
> Only if chunk size >> size of 1 track could you seek over a
> chunk. And you have to hope that by the time you have seeked the star=
t
> of the next chunk hasn't rotated past the head yet.
>
> Anyone know what the size of a track is on modern disks? How many
> sectors/track do they have?
>  =20

It varies to keep the bpi constant, so there are more sectors on outer=20
tracks and transfer rate is higher. raid10 can use outer tracks in more=
=20
cases (with the "far" layout) and thus delivers a higher transfer rate.=
=20
Or so the theory goes, in practice raid10 *does* give a higher transfer=
=20
rate, so the above is theory to explain the observed facts.

--=20
Bill Davidsen <davidsen@tmr.com>
  Even purely technical things can appear to be magic, if the documenta=
tion is
obscure enough. For example, PulseAudio is configured by dancing naked =
around a
fire at midnight, shaking a rattle with one hand and a LISP manual with=
 the
other, while reciting the GNU manifesto in hexadecimal. The documentati=
on fails
to note that you must circle the fire counter-clockwise in the southern
hemisphere.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
