From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Reduce number of active RAID1 devices
Date: Mon, 30 Jan 2012 20:06:33 +0100
Message-ID: <4F26EA39.5060800@computer.org>
References: <4F26E401.6000205@computer.org> <CALJXSJrYTuMRYfho05XXMFX0e1hekbm5BUtA5EhhO1HmOiBeig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJrYTuMRYfho05XXMFX0e1hekbm5BUtA5EhhO1HmOiBeig@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/30/2012 07:53 PM, J=C3=A9r=C3=B4me Poulin wrote:
> On Mon, Jan 30, 2012 at 1:40 PM, Jan Ceuleers<jan.ceuleers@computer.o=
rg>  wrote:
>> md0 : active raid1 sdb2[3] sde1[2] sdd1[0]
>>       521984 blocks [4/3] [U_UU]
> You must first fail and remove a device from the array, reduce to 2
> components and add back the spare which will appear as sdxN (S). You
> can do this online.
>
That works, thank you very much.

root@zotac:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]=20
[raid4] [raid10]
md1 : active raid1 sdb3[2](S) sde2[1] sdd2[0]
       487861824 blocks [2/2] [UU]

md0 : active raid1 sdb2[2](S) sde1[1] sdd1[0]
       521984 blocks [2/2] [UU]

unused devices: <none>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
