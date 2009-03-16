From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: sync_action repair not reading all sectors?
Date: Mon, 16 Mar 2009 11:20:45 -0400
Message-ID: <87f94c370903160820j6d96ce36t743bfca4a1cfea5e@mail.gmail.com>
References: <49BE3786.50809@dgreaves.com>
	 <F2C688D6A021E34CB81C0E631EF4C093014C015D@34093-C4-EVS1.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F2C688D6A021E34CB81C0E631EF4C093014C015D@34093-C4-EVS1.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: David Greaves <david@dgreaves.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 16, 2009 at 11:04 AM, David Lethe <david@santools.com> wrot=
e:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of David Greaves
>> Sent: Monday, March 16, 2009 6:27 AM
>> To: Neil Brown; linux-raid@vger.kernel.org
>> Subject: sync_action repair not reading all sectors?
>>
>> I have a drive that has bad sectors. Lots of them.
>>
>> smartctl shows
>> # 1 =A0Short offline =A0 =A0 =A0 Completed: read failure =A0 =A0 =A0=
 20% =A0 =A0 =A0 530
>> 1953520877
>>
>> A simple ddrescue to this part of the disk gets this:
>>
>> Mar 16 10:41:28 elm kernel: [ 8643.123397] sd 3:0:0:0: [sdd]
> 1953525168
>> 512-byte
>> hardware sectors (1000205 MB)
>> <snip<>51/40:00:f0:5c:70/00:00:74:00:00/e0 Emask 0x9 (media error)
>> Mar 16 10:41:29 elm kernel: [ 8644.190060] ata4.00: status: { DRDY E=
RR
>> }
>> Mar 16 10:41:29 elm kernel: [ 8644.190099] ata4.00: error: { UNC }
>>
>> and reports 30 or so errors.
>>
>>
>> mdstat tells me:
>> md0 : active raid5 sdd1[0] sdb1[2] sda1[1]
>> =A0 =A0 =A0 1953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] =
[UUU]
>>
>> So sdd1 is in there.
>>
>> /dev/sdd1 is the full disk
>>
>> Now this is an enterprise class disk so I thought re-writing the
> blocks
>> would be
>> worthwhile as a first step. (It is being RMAed but if it succeeds th=
en
>> I'll stop
>> the array, mirror/replace the disk and start the array - less risky
>> than a resync).
>>
>> However (two runs of)
>> =A0 echo repair > /sys/block/md0/md/sync_action
>> ran to completion without *any* errors being reported in syslog (or
>> anywhere)
>>
>> Is this expected? It suggests that it isn't reading the bad parts of
>> sdd. It
>> certainly hasn't repaired it and I'm none the wiser...
>>
>> kernel is 2.6.26-1-xen-686
>> mdadm v2.6.7.2
>>
>>
>> PS
>> This is an excellent place where I'd love to add in a new 'spare'
> disk,
>> mirror
>> sdd to the new disk (apart from the bad sectors which should come fr=
om
>> the
>> array) and then swap new for old.
>> Instead I'm going to have to go degraded and sync - risking a sector
>> read
>> failure on one of the other drives and a restore from backup :(
>>
>> --
>> "Don't worry, you'll be fine; I saw it work in a cartoon once..."
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> Personally, If I had a disk that just got this many bad sectors, then=
 I
> wouldn't mess
> with it further. =A0Just RMA it and get it out of your computer. Ever=
y
> block of data
> you write to that disk is at risk, and since you are running RAID5, t=
hen
> you have no room
> for error if this disk, or one of the others should die on you and yo=
u
> have a bad block
> on one of the surviving disks.
>
> David

David,

I think you read too fast.  That is exactly what he proposed.  The
question was how to keep the raid-5 as fault tolerant as possible
during the drive swapout.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
