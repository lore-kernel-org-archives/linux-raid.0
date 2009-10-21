From: "Majed B." <majedb@gmail.com>
Subject: Re: BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]
Date: Wed, 21 Oct 2009 08:02:00 +0300
Message-ID: <70ed7c3e0910202202y53231834y639db36af6e964db@mail.gmail.com>
References: <F574C415-FFB3-4BF0-A00F-85C8FC41691C@crc.id.au>
	<70ed7c3e0910202201g13ffa18di7eddd625ffca52fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910202201g13ffa18di7eddd625ffca52fc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And it's not serious.

On Wed, Oct 21, 2009 at 8:01 AM, Majed B. <majedb@gmail.com> wrote:
> Hello,
>
> I believe this has been fixed in 2.6.30 or 2.6.31.
>
> On Wed, Oct 21, 2009 at 5:46 AM, Steven Haigh <netwiz@crc.id.au> wrot=
e:
>> When trying to run a check using:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0echo check > /sys/block/md2/md/sync_actio=
n
>>
>> I got the following errors printed to the console:
>>
>> Oct 21 13:31:03 wireless kernel: md: syncing RAID array md2
>> Oct 21 13:31:03 wireless kernel: md: minimum _guaranteed_ reconstruc=
tion
>> speed: 1000 KB/sec/disc.
>> Oct 21 13:31:03 wireless kernel: md: using maximum available idle IO
>> bandwidth (but not more than 20000 KB/sec) for reconstruction.
>> Oct 21 13:31:03 wireless kernel: md: using 128k window, over a total=
 of
>> 300511808 blocks.
>> BUG: soft lockup - CPU#0 stuck for 10s! [md2_raid1:358]
>>
>> Pid: 358, comm: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0md2_raid1
>> EIP: 0060:[<c04ec1bc>] CPU: 0
>> EIP is at memcmp+0xd/0x22
>> =C2=A0EFLAGS: 00000202 =C2=A0 =C2=A0Not tainted =C2=A0(2.6.18-164.el=
5 #1)
>> EAX: 00000000 EBX: e2826fe0 ECX: d15f3fe0 EDX: 00000000
>> ESI: 00000020 EDI: 00000090 EBP: f70b8e40 DS: 007b ES: 007b
>> CR0: 8005003b CR2: 0806af70 CR3: 37872000 CR4: 000006d0
>> =C2=A0[<f8843c64>] raid1d+0x270/0xbea [raid1]
>> =C2=A0[<c0616870>] schedule+0x9cc/0xa55
>> =C2=A0[<c0616f33>] schedule_timeout+0x13/0x8c
>> =C2=A0[<c05a6b5e>] md_thread+0xdf/0xf5
>> =C2=A0[<c0434907>] autoremove_wake_function+0x0/0x2d
>> =C2=A0[<c05a6a7f>] md_thread+0x0/0xf5
>> =C2=A0[<c0434845>] kthread+0xc0/0xeb
>> =C2=A0[<c0434785>] kthread+0x0/0xeb
>> =C2=A0[<c0405c53>] kernel_thread_helper+0x7/0x10
>> =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>> Oct 21 13:37:50 wireless kernel: BUG: soft lockup - CPU#0 stuck for =
10s!
>> [md2_raid1:358]
>> Oct 21 13:37:50 wireless kernel:
>> Oct 21 13:37:50 wireless kernel: Pid: 358, comm: =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0md2_raid1
>> Oct 21 13:37:50 wireless kernel: EIP: 0060:[<c04ec1bc>] CPU: 0
>> Oct 21 13:37:50 wireless kernel: EIP is at memcmp+0xd/0x22
>> Oct 21 13:37:50 wireless kernel: =C2=A0EFLAGS: 00000202 =C2=A0 =C2=A0=
Not tainted
>> =C2=A0(2.6.18-164.el5 #1)
>> Oct 21 13:37:50 wireless kernel: EAX: 00000000 EBX: e2826fe0 ECX: d1=
5f3fe0
>> EDX: 00000000
>> Oct 21 13:37:50 wireless kernel: ESI: 00000020 EDI: 00000090 EBP: f7=
0b8e40
>> DS: 007b ES: 007b
>> Oct 21 13:37:50 wireless kernel: CR0: 8005003b CR2: 0806af70 CR3: 37=
872000
>> CR4: 000006d0
>> Oct 21 13:37:50 wireless kernel: =C2=A0[<f8843c64>] raid1d+0x270/0xb=
ea [raid1]
>> Oct 21 13:37:50 wireless kernel: =C2=A0[<c0616870>] schedule+0x9cc/0=
xa55
>> Oct 21 13:37:50 wireless kernel: =C2=A0[<c0616f33>] schedule_timeout=
+0x13/0x8c
>> Oct 21 13:37:50 wireless kernel: =C2=A0[<c05a6b5e>] md_thread+0xdf/0=
xf5
>> Oct 21 13:37:51 wireless kernel: =C2=A0[<c0434907>]
>> autoremove_wake_function+0x0/0x2d
>> Oct 21 13:37:51 wireless kernel: =C2=A0[<c05a6a7f>] md_thread+0x0/0x=
f5
>> Oct 21 13:37:51 wireless kernel: =C2=A0[<c0434845>] kthread+0xc0/0xe=
b
>> Oct 21 13:37:51 wireless kernel: =C2=A0[<c0434785>] kthread+0x0/0xeb
>> Oct 21 13:37:51 wireless kernel: =C2=A0[<c0405c53>] kernel_thread_he=
lper+0x7/0x10
>> Oct 21 13:37:51 wireless kernel: =C2=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>> This is using CentOS 5.3 with Kernel 2.6.18-164.el5 on an i686.
>>
>> Is this a serious type error? Is there anything else I can supply to
>> diagnose things more?
>>
>> # mdadm --detail /dev/md2
>> /dev/md2:
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 00.90.03
>> =C2=A0Creation Time : Mon Feb 23 17:15:41 2009
>> =C2=A0 =C2=A0 Raid Level : raid1
>> =C2=A0 =C2=A0 Array Size : 300511808 (286.59 GiB 307.72 GB)
>> =C2=A0Used Dev Size : 300511808 (286.59 GiB 307.72 GB)
>> =C2=A0 Raid Devices : 2
>> =C2=A0Total Devices : 2
>> Preferred Minor : 2
>> =C2=A0 =C2=A0Persistence : Superblock is persistent
>>
>> =C2=A0 =C2=A0Update Time : Wed Oct 21 13:46:28 2009
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean, resyncing
>> =C2=A0Active Devices : 2
>> Working Devices : 2
>> =C2=A0Failed Devices : 0
>> =C2=A0Spare Devices : 0
>>
>> =C2=A0Rebuild Status : 5% complete
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : fed99e3d:d08fdcc9:b9593a45=
:2cc09736
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 0.30584
>>
>> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice Stat=
e
>> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 =C2=
=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/hda3
>> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A022 =C2=A0 =C2=A0 =C2=A0 =C2=
=A03 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0=
 /dev/hdc3
>>
>>
>> --
>> Steven Haigh
>>
>> Email: netwiz@crc.id.au
>> Web: http://www.crc.id.au
>> Phone: (03) 9001 6090 - 0412 935 897
>>
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
