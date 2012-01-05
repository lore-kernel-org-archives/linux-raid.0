From: "Cal Leeming [Simplicity Media Ltd]"
	<cal.leeming@simplicitymedialtd.co.uk>
Subject: Re: RAID1 fail did not work properly with SSDs
Date: Thu, 5 Jan 2012 02:25:04 +0000
Message-ID: <CALvtuFSczhW6_5h8dSuTKetApGuiTB+fuRajDESb6NDGMu0PFg@mail.gmail.com>
References: <CALvtuFRKjcttSghvvKqOMKSgmAw8yCNkAipVVZD1hR=+qgpvqQ@mail.gmail.com>
	<CALvtuFSc3BfFrEA8JPjPcWEkkqg71Ni7wzr_15F9YqDt+1OV4A@mail.gmail.com>
	<20120105130047.6554e5f9@notabene.brown>
	<CALvtuFSK9GTRTguQXGqreL_njy72S8d+ExB+t1vT+wkjCNMbFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALvtuFSK9GTRTguQXGqreL_njy72S8d+ExB+t1vT+wkjCNMbFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow, talk about bad timing.

Just had an alert raised from our systems to say that /dev/sda has
just failed - I guess /dev/sdd was 100% dead, and /dev/sda was just
playing hide and seek :)

Really sorry for raising this, I genuinely thought there was a problem
with the kernel in some sorts.

Thanks for your quick response though!

Cal

On Thu, Jan 5, 2012 at 2:18 AM, Cal Leeming [Simplicity Media Ltd]
<cal.leeming@simplicitymedialtd.co.uk> wrote:
> Hi Neil,
>
> Terribly sorry, I had pasted the wrong lines from mdstat, here is the
> correct info:
>
> md1 : active (auto-read-only) raid1 sdd1[0] sda1[1]
> =A0 =A0 =A0975860 blocks super 1.2 [2/2] [UU]
>
> Also, I don't know if this is related and will probably sound crazy
> but, every single disk in the server (there was another unrelated
> RAID1 with non SDDs - sdb and sdc) were reporting this same error, bu=
t
> the moment I disabled the broken SSD in BIOS, it stopped doing this.
>
> =A0root@vicky [/sbin] > dmesg | grep sda | grep "I/O error" | wc -l
> 445
>
> =A0root@vicky [/sbin] > dmesg | grep sdb | grep "I/O error" | wc -l
> 2
>
> =A0root@vicky [/sbin] > dmesg | grep sdc | grep "I/O error" | wc -l
> 2
>
> =A0root@vicky [/sbin] > dmesg | grep sdd | grep "I/O error" | wc -l
> 2
>
> =A0root@vicky [/sbin] >
>
> And here's the really crazy thing.. the broken SSD was actually
> /dev/sdd, not /dev/sda.
>
> I did a badblocks check on both, sdd failed and sda worked fine.
> Removed sdd, and the I/O error problem disappeared on both sdd and
> sda.
>
> Could this be the reason why it ended up being placed into read-only
> mode? Because the kernel detected that the controller was saying that
> both SSDs were giving this same "I/O Error" (despite it being caused
> by a single drive)??
>
> Cal
>
>
> On Thu, Jan 5, 2012 at 2:00 AM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 5 Jan 2012 01:44:10 +0000 "Cal Leeming [Simplicity Media Ltd=
]"
>> <cal.leeming@simplicitymedialtd.co.uk> wrote:
>>
>>> Hi all,
>>>
>>> My apologies if this is the wrong mailing list for this issue, but =
I
>>> figured my email would be lost in volume if I sent to 'linux-kernel=
'.
>>
>> too true!!
>>
>>>
>>> In short, I had 2 SSDs in RAID 1, allocated as a single physical
>>> volume, which had a LVM logical volume mounted as the root partitio=
n.
>>>
>>> Six months later, one of the SSDs dies, and causes all of hell to b=
reak lose:
>>>
>>> [27087.234675] sd 0:0:0:0: [sda] Unhandled error code
>>> [27087.234686] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_BAD_TARGET
>>> driverbyte=3DDRIVER_OK
>>> [27087.234688] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 68 53 88 0=
0 00 08 00
>>> [27087.234693] end_request: I/O error, dev sda, sector 6837128
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 ^^^^^^^^
>>
>> "sda".
>>
>>> ^^ repeated over 9000 times
>>>
>>> Instead of the disk being marked as failed and removed, the root
>>> partition was instead remounted as read-only, mdadm showed no
>>> problems,=A0and required a reboot.
>>>
>>> Upon rebooting, RAID still hadn't marked the dying disk as failed o=
r
>>> removed, and began to re-sync!
>>>
>>> =A0root@vicky [/var/log] > cat /proc/mdstat
>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [=
raid4]
>>> md0 : active (auto-read-only) raid1 sdb1[0] sdc1[1]
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0^^^^^^^^^^^^^^^
>>
>> "sdb" and "sdc".
>>
>> Something is missing in this picture.
>>
>> NeilBrown
>>
>>
>>> =A0 =A0 =A0 78122967 blocks super 1.2 [2/2] [UU]
>>>
>>> On top of this, even though it was read-only, it kept giving this
>>> error for everything:
>>>
>>> =A0root@vicky [/var/log] > shutdown
>>> bash: /sbin/shutdown: Input/output error
>>>
>>> I'm not sure if what I'm seeing here is normal, but thought I shoul=
d
>>> at least try and ask - I can provide lots more info if needed (got =
a
>>> huge text file and several screenshots).
>>>
>>> Any feedback would be very much appreciated.
>>>
>>> Cal Leeming
>>> Simplicity Media Ltd
>>>
>>> ----------------------------
>>>
>>> Here is the short smartctl dump of the disk:
>>>
>>> =A0root@vicky [/home/foxx] > smartctl -a /dev/sda
>>> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local bu=
ild)
>>> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourcefo=
rge.net
>>>
>>> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
>>> Device Model: =A0 =A0 M4-CT128M4SSD2
>>> Serial Number: =A0 =A000000000111603061D7B
>>> Firmware Version: 0001
>>> User Capacity: =A0 =A0128,035,676,160 bytes
>>> Device is: =A0 =A0 =A0 =A0Not in smartctl database [for details use=
: -P showall]
>>> ATA Version is: =A0 8
>>> ATA Standard is: =A0ATA-8-ACS revision 6
>>> Local Time is: =A0 =A0Tue Jan =A03 13:54:46 2012 GMT
>>> SMART support is: Available - device has SMART capability.
>>> SMART support is: Enabled
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
