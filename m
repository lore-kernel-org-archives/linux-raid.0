From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Awful RAID5 random read performance
Date: Wed, 03 Jun 2009 20:57:34 +0100
Message-ID: <4A26D5AE.2000003@anonymous.org.uk>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com> <20090602194704.GA30639@rap.rap.dk> <4A25B201.2000705@anonymous.org.uk> <4A26C313.6080700@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A26C313.6080700@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2009 19:38, Bill Davidsen wrote:
> John Robinson wrote:
>> On 02/06/2009 20:47, Keld J=F8rn Simonsen wrote:
[...]
>>> In your case, using 3 disks, raid5 should give about 210 % of the=20
>>> nominal
>>> single disk speed for big file reads, and maybe 180 % for big file
>>> writes. raid10,f2 should give about 290 % for big file reads and 14=
0%
>>> for big file writes. Random reads should be about the same for raid=
5 and
>>> raid10,f2 - raid10,f2 maybe 15 % faster, while random writes should=
 be
>>> mediocre for raid5, and good for raid10,f2.
>>
>> I'd be interested in reading about where you got these figures from=20
>> and/or the rationale behind them; I'd have guessed differently...
>=20
> For small values of N, 10,f2 generally comes quite close to N*Sr, whe=
re=20
> N is # of disks and Sr is single drive read speed. This is assuming=20
> fiarly large reads and adequate stripe buffer space. Obviously for=20
> larger values of N that saturates something else in the system, like =
the=20
> bus, before N gets too large. I don't generally see more than (N/2-1)=
*Sw=20
> for write, at least for large writes. I came up with those numbers ba=
sed=20
> on testing 3-4-5 drive arrays which do large file transfers. If you w=
ant=20
> to read more than large file speed into them, feel free.

Actually it was the RAID-5 figures I'd have guessed differently. I'd=20
expect ~290% (rather than 210%) for big 3-disc RAID-5 reads, and ~140%=20
(rather than "mediocre") for random small writes. But of course I=20
haven't tested.

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
