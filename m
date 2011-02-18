From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 13:29:44 +0000
Message-ID: <AANLkTi=Yn4wWzRR2huY0asTHB8brcgF8PCkpvtrqmQBK@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
	<AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>
	<4D5E7123.5020103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5E7123.5020103@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

top - 13:28:45 up 1 day, 39 min, 12 users,  load average: 2.65, 2.49, 2=
=2E37
Tasks: 340 total,   7 running, 333 sleeping,   0 stopped,   0 zombie
Cpu0  : 47.9%us, 15.0%sy,  0.0%ni, 13.7%id, 21.5%wa,  0.0%hi,  2.0%si, =
 0.0%st
Cpu1  : 54.8%us,  8.7%sy,  0.0%ni, 33.3%id,  3.2%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu2  : 46.5%us, 13.7%sy,  0.0%ni, 37.9%id,  1.9%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu3  : 49.5%us,  9.5%sy,  0.0%ni, 37.6%id,  3.4%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu4  : 48.7%us,  8.2%sy,  0.0%ni, 17.3%id, 25.5%wa,  0.0%hi,  0.3%si, =
 0.0%st
Cpu5  : 50.3%us,  7.2%sy,  0.0%ni, 41.8%id,  0.6%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu6  : 53.5%us,  6.6%sy,  0.0%ni, 38.4%id,  1.6%wa,  0.0%hi,  0.0%si, =
 0.0%st
Cpu7  : 52.0%us,  6.2%sy,  0.0%ni, 41.2%id,  0.6%wa,  0.0%hi,  0.0%si, =
 0.0%st
Mem:  12299244k total, 12227064k used,    72180k free, 10754600k buffer=
s
Swap: 11534332k total,        0k used, 11534332k free,   175916k cached


On 18 February 2011 13:16, Phil Turmel <philip@turmel.org> wrote:
> On 02/18/2011 04:31 AM, Simon Mcnair wrote:
>> time passes. =A0You are eaten by a Grue. =A0Sheesh this is taking a =
long time.
>>
>> simon@proxmox:~$ top
>>
>> top - 09:26:19 up 20:36, 11 users, =A0load average: 2.46, 2.49, 2.39
>> Tasks: 334 total, =A0 9 running, 325 sleeping, =A0 0 stopped, =A0 0 =
zombie
>> Cpu(s): 52.8%us, =A09.4%sy, =A00.0%ni, 35.2%id, =A02.5%wa, =A00.0%hi=
, =A00.2%si, =A00.0%st
>> Mem: =A012299244k total, 12227584k used, =A0 =A071660k free, 1104286=
8k buffers
>> Swap: 11534332k total, =A0 =A0 =A0 =A00k used, 11534332k free, =A0 2=
08204k cached
>>
>> =A0 PID USER =A0 =A0 =A0PR =A0NI =A0VIRT =A0RES =A0SHR S %CPU %MEM =A0=
 =A0TIME+ =A0COMMAND
>> 18896 root =A0 =A0 =A020 =A0 0 12288 1072 =A0460 S =A0 63 =A00.0 431=
:16.55 ntfs-3g
>> 18909 root =A0 =A0 =A020 =A0 0 12288 1064 =A0460 R =A0 62 =A00.0 419=
:17.11 ntfs-3g
>> 18920 root =A0 =A0 =A020 =A0 0 12288 1100 =A0492 R =A0 62 =A00.0 428=
:17.33 ntfs-3g
>> =A09210 root =A0 =A0 =A020 =A0 0 =A04068 =A0520 =A0328 S =A0 54 =A00=
=2E0 661:59.92 gzip
>> =A09138 root =A0 =A0 =A020 =A0 0 =A04068 =A0524 =A0328 R =A0 53 =A00=
=2E0 647:29.07 gzip
>> =A09247 root =A0 =A0 =A020 =A0 0 =A04068 =A0524 =A0328 S =A0 53 =A00=
=2E0 651:28.36 gzip
>> 25678 root =A0 =A0 =A020 =A0 0 =A04068 =A0524 =A0328 R =A0 52 =A00.0=
 439:49.20 gzip
>> 24957 root =A0 =A0 =A020 =A0 0 =A04068 =A0524 =A0328 R =A0 51 =A00.0=
 437:44.01 gzip
>> 25792 root =A0 =A0 =A020 =A0 0 =A04068 =A0524 =A0328 S =A0 48 =A00.0=
 433:28.14 gzip
>>
>> This is hardly touching the CPU on the box (in my opinion), any advi=
ce
>> on using renice ? =A0I've never used it before, but now seems like a
>> good time ?
>
> Probably wouldn't help.
>
> You have a total usage of 65%. =A0I suspect that each of the processo=
rs running gzip are nearly pegged, and everything else is loafing along=
=2E =A0Hit '1' in top to show the CPU usage per-cpu. =A0Single-threaded=
 gzip is holding you back.
>
> If you had enough space for saving the partitions uncompressed, it wo=
uld be much faster. =A0The PCIe x4 interface on the SuperMicro has a th=
eoretical performance of 1GByte/s, which would be ~ 125MB/s per drive. =
=A0From what I've read, that card actually delivers ~ 75MB/s per drive =
when they're all busy.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
