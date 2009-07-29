From: Jon Nelson <jnelson-suse@jamponi.net>
Subject: Re: help with bad performing raid6
Date: Wed, 29 Jul 2009 10:57:32 -0500
Message-ID: <cccedfc60907290857s6560beecsa62ced930bc43552@mail.gmail.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
	<4A7065F1.3060203@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7065F1.3060203@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 29, 2009 at 10:08 AM, Bill Davidsen<davidsen@tmr.com> wrote=
:
> Jon Nelson wrote:
=2E.

>> When I say "bad performance" I mean writes that vary down to 100KB/s
>> or less, as reported by rsync. The "average" end-to-end speed for
>> writing large (500MB to 5GB) files hovers around 3-4MB/s. This is ov=
er
>> 100 MBit.
>>
>> Often times while stracing rsync I will see rsync not make a single
>> system call for sometimes more than a minute. Sometimes well in exce=
ss
>> of that. If I look at the load on the server the top process is
>> md0_raid5 (the raid6 process for md0, despite the raid5 in the name)=
=2E
>> The load hovers around 8 or 9 at this time.
>>
>>
>
> I really suspect disk errors, I assume nothing in /var/log/messages?

Nope. Nothing in /v/l/m. I'm rather strongly beginning to suspect some
sort of weird NFS issue.

> Perhaps iostat looking at the underlying drives would tell you someth=
ing.

> You might also run iostat with a test write load to see if something =
is
> unusual:
> =A0dd if=3D/dev/zero bs=3D1024k count=3D1024k of=3DBigJunk.File conv=3D=
fdatasync

During this test, vmstat reports blocks out of (infrequent) lows of
25000 to about 70000. The values seem to hover in the mid 60K (65MB/s
give or take). That seems very reasonable.

> Of course if it runs like a bat out hell, it tells you the problem is
> elsewhere.

> Other possible causes are a poor chunk size, bad alignment of the who=
le
> filesystem, and many other things too ugly to name. The fact that you=
 use
> LVM make alignment issue more likely (in the sense of "one more level=
 which
> could mess up"). Checked the error count on the array?

Well, since I can write some 25-30MB/s (actual underlying I/O much
higher obviously) to the same filesystem, and load hovers around 2.5
I'm suspecting some weird NFS issue.

The md0_raid5 process is in R or S most of the time, with about 30% of =
the CPU.

Summary: writing large files over NFS causes huge load and really
awful performance. Writing similarly large files directly (same
underlying filesystem, ext3) performs as expected without huge load.
Therefore, I am going to assume this is an NFS issue. I've more than
my fair share of NFS issues lately. :-(

PS. I'm running 2.6.27.25 stock openSUSE kernel. I just checked and it
does not apper to have the "NFS packet storm" patches which seems to
cause 2.6.27.X NFS performance to really suck.

Sorry for wasting everybody's time.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
