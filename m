From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: 2.6.39: raid1 check blocks jbd on other md more than 120 seconds
Date: Thu, 2 Jun 2011 11:46:38 +0200
Message-ID: <BANLkTimzMOo9uGjt-sDWPVBBdzSQaqVTWw@mail.gmail.com>
References: <20110602093644.GA8620@janus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110602093644.GA8620@janus>
Sender: linux-raid-owner@vger.kernel.org
To: Frank van Maarseveen <frankvm@frankvm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2 June 2011 11:36, Frank van Maarseveen <frankvm@frankvm.com> wrote:
> The system runs FC14 with an (almost) stock 2.6.39 kernel, configured=
 to
> panic if it seems to hang. That's exactly what started to happen with=
out
> anything being logged in the normal way except over netconsole.
>
> /proc/mdstat:
> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> md3 : active raid1 sda3[0] sdb3[1]
> =C2=A0 =C2=A0 =C2=A01885338488 blocks super 1.2 [2/2] [UU]
>
> md1 : active raid1 sda1[0] sdb1[1]
> =C2=A0 =C2=A0 =C2=A033555384 blocks super 1.2 [2/2] [UU]
>
> kernel messages:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(/etc/cron.weekly/99-raid-check kicks in)
> Jun =C2=A02 04:04:00 janus md: data-check of RAID array md3
> Jun =C2=A02 04:04:00 janus md: delaying data-check of md1 until md3 h=
as finished (they share one or more physical units)
> Jun =C2=A02 04:04:00 janus md: minimum _guaranteed_ =C2=A0speed: 1000=
 KB/sec/disk.
> Jun =C2=A02 04:04:00 janus md: using maximum available idle IO bandwi=
dth (but not more than 200000 KB/sec) for data-check.
> Jun =C2=A02 04:04:00 janus md: using 128k window, over a total of 188=
5338488 blocks.
> Jun =C2=A02 04:55:54 janus INFO: task jbd2/md1-8:1188 blocked for mor=
e than 120 seconds.
> Jun =C2=A02 04:55:54 "echo 0 > /proc/sys/kernel/hung_task_timeout_sec=
s" disables this message.
> Jun =C2=A02 04:55:54 janus jbd2/md1-8 =C2=A0 =C2=A0 D
> Jun =C2=A02 04:55:54 =C2=A0f5739e68
> Jun =C2=A02 04:55:54 janus =C2=A0 =C2=A00 =C2=A01188 =C2=A0 =C2=A0 =C2=
=A02 0x00000000
> Jun =C2=A02 04:55:54 =C2=A0f5739e78
> Jun =C2=A02 04:55:54 =C2=A000000046
> Jun =C2=A02 04:55:54 =C2=A000000002
> Jun =C2=A02 04:55:54 =C2=A0f5739e68
> Jun =C2=A02 04:55:54 =C2=A000000000
> Jun =C2=A02 04:55:54 =C2=A001000000
> Jun =C2=A02 04:55:54 =C2=A0f5739e08
> Jun =C2=A02 04:55:54 =C2=A0f6124f00
> Jun =C2=A02 04:55:54 janus
> Jun =C2=A02 04:55:54 =C2=A0c1999c00
> Jun =C2=A02 04:55:54 =C2=A000000001
> Jun =C2=A02 04:55:54 =C2=A0c1999680
> Jun =C2=A02 04:55:54 =C2=A0c1999680
> Jun =C2=A02 04:55:54 =C2=A000000003
> Jun =C2=A02 04:55:54 =C2=A0f6126940
> Jun =C2=A02 04:55:54 =C2=A0f6126ac0
> Jun =C2=A02 04:55:54 =C2=A0f6786680
> Jun =C2=A02 04:55:54 janus
> Jun =C2=A02 04:55:54 =C2=A0000045d1
> Jun =C2=A02 04:55:54 =C2=A000000000
> Jun =C2=A02 04:55:54 =C2=A000000000
> Jun =C2=A02 04:55:54 =C2=A057087b88
> Jun =C2=A02 04:55:54 =C2=A0000045d1
> Jun =C2=A02 04:55:54 =C2=A0000045d1
> Jun =C2=A02 04:55:54 =C2=A0f6686c00
> Jun =C2=A02 04:55:54 =C2=A0f6686c10
> Jun =C2=A02 04:55:54 janus
> Jun =C2=A02 04:55:54 Call Trace:
> Jun =C2=A02 04:55:54 =C2=A0[<c103822b>] ? get_parent_ip+0xb/0x40
> Jun =C2=A02 04:55:54 =C2=A0[<c11698a2>] jbd2_journal_commit_transacti=
on+0x182/0x1500
> Jun =C2=A02 04:55:54 =C2=A0[<c100249f>] ? __switch_to+0xcf/0x1c0
> Jun =C2=A02 04:55:54 =C2=A0[<c103822b>] ? get_parent_ip+0xb/0x40
> Jun =C2=A02 04:55:54 =C2=A0[<c162f05c>] ? schedule+0x2ac/0x730
> Jun =C2=A02 04:55:54 =C2=A0[<c1056c90>] ? wake_up_bit+0x80/0x80
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(reboots)
>
> --
> Frank
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Same behavior if you lower this?

Jun  2 04:04:00 janus md: using maximum available idle IO bandwidth
(but not more than 200000 KB/sec) for data-check.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
