From: CoolCold <coolthecold@gmail.com>
Subject: Re: mdadm seems not be doing rewrites on unreadable blocks
Date: Tue, 30 Nov 2010 13:40:25 +0300
Message-ID: <AANLkTin+k_xDs0gS+NWpzdyMe5Qy7_iCL9cHpX5RmUUB@mail.gmail.com>
References: <87oc98jgqb.fsf@poker.hands.com>
	<20101130115214.0b818e48@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101130115214.0b818e48@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Philip Hands <phil@hands.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 30, 2010 at 3:52 AM, Neil Brown <neilb@suse.de> wrote:
> On Mon, 29 Nov 2010 15:23:56 +0000 Philip Hands <phil@hands.com> wrot=
e:
>
>> Hi,
>>
>> I have a server with some 2TB disks, that are partitioned, and those
>> partitions assembled as RAID1's.
>>
>> One of the disks has been showing non-zero Current_Pending_Sectors i=
n
>> smart, so I've added more disks to the machine, partitioned one of t=
he
>> new disks, and added each of it's partitions to the relevant RAID,
>> growing the raid to three devices to force the data to be written to=
 the
>> new disk.
>>
>> Initially, I did this under single user mode, so that was the only t=
hing
>> going on on the machine.
>>
>> One of the old drives (/dev/sda at the time, and the first disk in t=
he
>> RAID0) then started throwing lots of errors, which seemed to take a =
long
>> time to resolve each -- watching this made me think that, under the
>> circumstances, rather than continuing to read only from /dev/sda, it
>> might be bright to try reading from /dev/sdb (the other original dis=
k)
>> in order to provide the data for /dev/sdc (the new disk).
>
> I assume you mean "RAID1" where you wrote "RAID0" ??
>
> md has no knowledge of IO taking a long time. =A0If it works, it work=
s. =A0If it
> doesn't, md tries to recover. =A0If it got a read error it should cer=
tainly try
> to read from a different device and write the data back.
>
>>
>> Also, I got the impression that the data on the unreadable blocks wa=
s
>> not being written back to /dev/sda once it was finally read from
>> /dev/sdb (although confirming that wasn't easy when on the console, =
with
>> errors pouring up the screen, and the system being rather unresponsi=
ve,
>> so I rebooted -- after the reboot, it seemed to be getting along bet=
ter,
>> so I put it back in production).
>>
>> After waiting the several days it took to allow the third disk to be
>> populated with data, I thought I'd try forcing the unreadable sector=
s to
>> be written, to get them remapped if they were really bad, or just to=
 get
>> rid of the Current_Pending_Sector count if it was just a case of the
>> sectors being corrupt but the physical sector being OK.
>>
>> [BTW After some rearrangement while I was doing the install, the
>> doubtful disk is now /dev/sdb, while the newly copied disk is /dev/s=
dc]
>>
>> So choosing one of the sectors in question, I did:
>>
>> =A0 root# =A0dd bs=3D512 skip=3D19087681 seek=3D19087681 count=3D1 i=
f=3D/dev/sdc of=3D/dev/sdb
>> =A0 dd: writing `/dev/sdb': Input/output error
>> =A0 1+0 records in
>> =A0 0+0 records out
>> =A0 0 bytes (0 B) copied, 11.3113 s, 0.0 kB/s
>
> You should probably had added oflag=3Ddirect.
>
>
> When you write 512 byte blocks to a block device, it will read a 4096=
 byte
> block, update the 512 bytes, and write the 4096 bytes back.
>
>
>>
>> Which gives rise to this:
>>
>> [325487.740650] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 actio=
n 0x0
>> [325487.740746] ata2.00: irq_stat 0x00060002, device error via D2H F=
IS
>> [325487.740841] ata2.00: failed command: READ DMA
>
> Yep. =A0read error while trying to pre-read the 4K block.
Hmm, is true for any block device? i.e. if blockdev --getss reports
sector size is 512 byte. Or this is related to page size?

>
>
>> [325487.740924] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag=
 0 dma 4096 in
>> [325487.740925] =A0 =A0 =A0 =A0 =A0res 51/40:00:41:41:23/00:00:01:00=
:00/e1 Emask 0x9 (media error)
>> [325487.741153] ata2.00: status: { DRDY ERR }
>> [325487.741230] ata2.00: error: { UNC }
>> [325487.749790] ata2.00: configured for UDMA/100
>> [325487.749797] ata2: EH complete
>> [325489.757669] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 actio=
n 0x0
>> [325489.757759] ata2.00: irq_stat 0x00060002, device error via D2H F=
IS
>> [325489.757852] ata2.00: failed command: READ DMA
>> [325489.757936] ata2.00: cmd c8/00:08:40:41:23/00:00:00:00:00/e1 tag=
 0 dma 4096 in
>> [325489.757937] =A0 =A0 =A0 =A0 =A0res 51/40:00:41:41:23/00:00:01:00=
:00/e1 Emask 0x9 (media error)
>> [325489.758165] ata2.00: status: { DRDY ERR }
> ....
>
>
>> If I use hdparm's --write-sector on the same sector, it succeeds, an=
d
>> the dd then succeeds (unless there's another sector following that's
>> also bad). =A0This doesn't end up resulting in Reallocated_Sector_Ct
>> increasing (it's still zero on that disk), so it seems that the disk
>> thinks the physical sector is fine now that it's been written.
>>
>> I get the impression that for several of the sectors in question,
>> attempting to write the bad sector revealed a sector one or two
>> further into the disk that was also corrupt, so despite writing abou=
t 20
>> of them, the Pending sector count has actually gone up from 12 to 32=
=2E
>>
>> Given all that, it seems like this might be a good test case, so I
>> stopped fixing things in the hope that we'd be able to use the bad
>> blocks for testing.
>>
>> I have failed the disk out of the array though (which might be a bit=
 of
>> an mistake from the testing side of things, but seemed prudent since=
 I'm
>> serving live data from this server).
>>
>> So, any suggestions about how I can use this for testing, or why it
>> appears that mdadm isn't doing it's job a well as it might? =A0I wou=
ld
>> think that it should do whatever hdparm's --write-sector does to get=
 the
>> sector writable again, and then write the data back from the good di=
sk,
>> since leaving it with the bad blocks means that the RAID is degraded=
 for
>> those blocks at least.
>
> What exactly did you want to test, and what exactly makes you think m=
d isn't
> doing its job properly?
>
> By the sound of it, the drive is quite sick.
> I'm guessing that you get read errors, md tries to write good data an=
d
> succeeds, but then when you later come to read that block again you g=
et
> another error.
>
> I would suggest using dd (With a large block size) to write zero all =
over the
> device, then see if it reads back with no errors. =A0My guess is that=
 it won't.
>
> NeilBrown
>
>
>
>>
>> If it really cannot rewrite the sector then should it not be declari=
ng
>> the disk faulty? =A0Not that I think that would be the best thing to=
 do in
>> this circumstance, since it's clearly not _that_ faulty, but blithel=
y
>> carrying on when some of the data is no longer redundant seems broke=
n as
>> well.
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
