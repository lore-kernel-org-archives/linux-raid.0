From: "Majed B." <majedb@gmail.com>
Subject: Re: Random bit flips - better data integrity needed [Was: Re:
	mismatch_count != 0 on multiple hosts]
Date: Sun, 20 Sep 2009 12:43:34 +0300
Message-ID: <70ed7c3e0909200243p4cf47a19x8af74c5a946b0ac8@mail.gmail.com>
References: <87f94c370909190910s6992a671re507ddcf91ea623e@mail.gmail.com>
	<4AB5F788.6090701@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB5F788.6090701@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Check the thread started by Matthias within last week.

On Sun, Sep 20, 2009 at 12:36 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 19/09/2009 17:10, Greg Freemyer wrote:
> [...]
>>
>> I don't know how specifically, but it also seems to me the mdraid
>> stack could add to currently poor data integrity process even in the
>> absence of a supporting scsi subsystem. =C2=A0Maybe by pulling out t=
he
>> integrity checksum / crc info and putting it on yet another disk, or
>> mixing it in with the parity calculation.
>>
>> Specifically you could steal the second parity stripe from a raid 6
>> setup and replace it with this end-to-end data integrity checksum /
>> crc. =C2=A0The checksum / crc is much smaller than the original data=
 so the
>> one integrity disk should support a reasonable number of data disks.
>> Obviously this would not be one of the formal raid levels, but that
>> doesn't mean its not useful.
>
> I vaguely remember someone here was prototyping/developing a device m=
apper
> thingy which added checksumming/integrity to simulate high-end RAID c=
ards
> adding a checksum to each 512-byte sector by using 520- or 528-byte s=
ectors
> on their component discs. I don't remember the details, but what I ha=
ve in
> mind was something along the lines of using an extra sector on the
> underlying device per 64 sectors or so. There wouldn't be too heavy a=
n
> overhead on small reads - we do readahead anyway - and it would make =
small
> writes even more painful than they are already, but shouldn't signifi=
cantly
> reduce throughput on large (chunk size) reads and writes. I'd use it.
>
> Cheers,
>
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
