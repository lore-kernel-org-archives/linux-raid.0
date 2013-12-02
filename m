From: David Brown <david.brown@hesbynett.no>
Subject: Re: Raid10 multi core scaling
Date: Mon, 02 Dec 2013 09:19:45 +0100
Message-ID: <529C42A1.3010400@hesbynett.no>
References: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt> <20131202172207.7400e03a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131202172207.7400e03a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/12/13 07:22, NeilBrown wrote:
> On Tue, 26 Nov 2013 10:58:59 +0000 Pedro Teixeira <finas@aeiou.pt> wr=
ote:
>=20
>>    I created a Raid10 array with 16 sata 1TB disks and the array
>> performance
>> seems to be limited by the md0_raid10 taking 99% of one core and not
>> scalling to other cores. I tried overclocing the cpu cores and this =
lead to
>> a small increase in performance ( but md0_raid10 keeps eating 99% of=
 one
>> core ).
>=20
> Are you really talking about general array performance, or just resyn=
c
> performance?
>=20
> Because md0_raid10 doesn't do much work for normal IO so that should =
scale to
> multiple processors.
> I'm not sure that optimising resync to use more than one processor is=
 really
> much of a priority - is it?
>=20
> NeilBrown

I think that depends a bit on whether we are talking about md raid10, o=
r
raid1+0.  For md raid10, resyncs and rebuilds are always going to take =
a
bit of time - data has to be copied back and forth across the same
disks, with a lot of head movement (especially for "far" layout).  I
don't see that it would take much cpu time, however.  And this sort of
layout is mostly for small arrays - it gives great performance when you
have two drives, and perhaps up to about 4 drives.  But after that,
people probably want raid1+0 layouts (i.e., raid0 stripes of raid1 pair=
s).

=46or raid1 + 0, resync time /is/ important - it is one of the reasons
people pick it, especially the time to resync a single replaced drive.
But again, I can't see how that would take cpu time.

I suppose that when doing the initial sync of this 16 disk array, you
have to read in all data from 8 disks and write it out to the other 8
disks.  That's a lot of IO passing through the cpus, even if there is n=
o
calculations going on.  But I thought each raid1 pair already had its
own thread, so this would be scaled across 8 cores?  Is md raid10
limited to just one thread?

mvh.,

David


>=20
>=20
>>
>>    I'm using:
>>     - a phenom X6 at 3600mhz
>>     - 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cache )
>>     - 4x marvell 9230 sata3 controllers ( 4 ports each ) pcie 2.0 2x
>> lanes.
>>     - 8GB ram
>>     - custom 3.12 kernel and mdadm compiled from latest source
>>
>>    what I did to test performance was to force a check on the array,=
 and
>> this
>> leads to mdadm reporting a speed of about 990000K/sec. The hard disk=
s
>> report a 54% utilization. ( Overclocking the cpu by 200mhz increases=
 the
>> resync speed a bit and the hdd's utilizartion to about 58% )
>>
>>    If I do the same with a raid5 array instead of raid10, them resyn=
c
>> speed
>> will be almost double of raid10, the harddisk utilization reported w=
ill be
>> 98-100% and I can see at least two cores being used.
>>
>> ____________________________________________________________________=
____________
>> Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
>> http://www.aeiou.pt
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
