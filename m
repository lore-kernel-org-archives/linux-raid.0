From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 2 Aug 2012 14:22:01 -0300
Message-ID: <CABYL=Tp5eMYA=KfqZkAbZs1f3cwjfL7zdjCfENSBufE66+p7aw@mail.gmail.com>
References: <50191ADE.10809@fastmail.fm>
	<5019D052.4000409@hardwarefreak.com>
	<20120802091917.32fb0ca5@natsu>
	<501A316C.3020305@hardwarefreak.com>
	<20120802140634.6f729d07@natsu>
	<1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com>
	<CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
	<501AB553.2030003@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <501AB553.2030003@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yes, that=C2=B4s what i know too
the point is  develop a algorithm to make this in block level like a md=
 device
it write to disk and check if it was write ok
it read from disk and check parity, if it=C2=B4s wrong read again, afte=
r X
times reading wrong report it as a badblock (now a silent corruption
becomes a well know badblock disk corruption)

i think that=C2=B4s all... just need someone to implement it, some idea=
s:

// create:
mdadm --create /dev/md0 --level=3Dintegrity /dev/sda1

// check:
echo "check" > /sys/block/md0/md/sync_action

// repair: (like harddisks badblock recovery, mark the block as
badblock, and it will never be used)
echo "repair" > /sys/block/md0/md/sync_action

when using it with raid1 raid10 or any other mirror mdadm device, the
device with silent corruption can be reported (checksum don=C2=B4t matc=
h
data) as badblock (mdadm have news features to deal with badblocks...)
the disk with badblock will be ignored and read will be done in next
good disk...

we could use a md5 checksum (32bits?! - 4 bytes) and data with less
information, example today block is 512bytes.. change it to 508bytes
of data + 4 bytes of checksum

i think that=C2=B4s all...


2012/8/2 Jeff Johnson <jeff.johnson@aeoncomputing.com>:
> The only ways I know of to currently detect/repair silent data corrup=
tion
> are via the use of T10-DIF on SAS drives with 520-byte sectors and em=
bedded
> per block CRCs (bytes 513-520) or via a patented algorithm used in a
> commercial Linux software RAID product (www.streamscale.com).
>
> Neither approach is cost effective for small or personal use RAID
> applications.
>
>
> On 8/2/12 10:04 AM, Roberto Spadim wrote:
>>
>> well i think the integrity is know, but it=E6=84=80 not fully needed=
 since
>> the security isn=E6=84=92 a problem we can buy secure sata/sas
>>
>> controlers/disks
>> the main problem will be in some days when we are using SoC systems
>> and we only have USB to connect a harddrive... maybe when this becom=
e
>> more popular we will see a development of a module to have data
>> integrity (silient corruption detection and maybe repair)
>>
>
> --
> ------------------------------
> Jeff Johnson
> Manager
> Aeon Computing
>
> jeff.johnson@aeoncomputing.com
> www.aeoncomputing.com
> t: 858-412-3810 x101   f: 858-412-3845
> m: 619-204-9061
>
> /* New Address */
> 4170 Morena Boulevard, Suite D - San Diego, CA 92117
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
