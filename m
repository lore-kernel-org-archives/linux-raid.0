From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Awful RAID5 random read performance
Date: Thu, 04 Jun 2009 00:21:02 +0200
Message-ID: <878wk9q7qp.fsf@frosties.localdomain>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com>
	<200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com>
	<20090602194704.GA30639@rap.rap.dk>
	<4A25B201.2000705@anonymous.org.uk> <4A26C313.6080700@tmr.com>
	<4A26D5AE.2000003@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A26D5AE.2000003@anonymous.org.uk> (John Robinson's message of
	"Wed, 03 Jun 2009 20:57:34 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> On 03/06/2009 19:38, Bill Davidsen wrote:
>> John Robinson wrote:
>>> On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
> [...]
>>>> In your case, using 3 disks, raid5 should give about 210 % of the
>>>> nominal
>>>> single disk speed for big file reads, and maybe 180 % for big file
>>>> writes. raid10,f2 should give about 290 % for big file reads and 1=
40%
>>>> for big file writes. Random reads should be about the same for rai=
d5 and
>>>> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes shoul=
d be
>>>> mediocre for raid5, and good for raid10,f2.
>>>
>>> I'd be interested in reading about where you got these figures from
>>> and/or the rationale behind them; I'd have guessed differently...
>>
>> For small values of N, 10,f2 generally comes quite close to N*Sr,
>> where N is # of disks and Sr is single drive read speed. This is
>> assuming fiarly large reads and adequate stripe buffer
>> space. Obviously for larger values of N that saturates something
>> else in the system, like the bus, before N gets too large. I don't
>> generally see more than (N/2-1)*Sw for write, at least for large
>> writes. I came up with those numbers based on testing 3-4-5 drive
>> arrays which do large file transfers. If you want to read more than
>> large file speed into them, feel free.

With far copies reading is like reading raid0 and writing is like
raid0 but writing twice with a seek between each. So (N/2) and (N/2-a
bit) are the theoretical maximums and raid10 comes damn close to those.

> Actually it was the RAID-5 figures I'd have guessed differently. I'd
> expect ~290% (rather than 210%) for big 3-disc RAID-5 reads, and ~140=
%
> (rather than "mediocre") for random small writes. But of course I
> haven't tested.

That kind of depends on the chunk size I think.

Say you have a raid 5 with chunk size << size of 1 track. Then on each
disk you read 2 chunks, skip a chunk, read 2 chunks, skip a chunk. But
skipping a chunk means waiting for the disk to rotate over it. That
takes as long as reading it. You shouldn't even get 210% speed.

Only if chunk size >> size of 1 track could you seek over a
chunk. And you have to hope that by the time you have seeked the start
of the next chunk hasn't rotated past the head yet.

Anyone know what the size of a track is on modern disks? How many
sectors/track do they have?

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
