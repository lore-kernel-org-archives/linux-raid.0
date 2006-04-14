From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: Kernel Oops while creating RAID5 MD array with bitmap support on 2.6.15 kernel
Date: Fri, 14 Apr 2006 17:24:49 +0530
Message-ID: <200604141154.k3EBsOFG027737@mailserver.spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

As per my previous mails, I am working on RAID5 performance with bitmap
support on 2.6.15 kernel, but facing some problems.

I am debugging the RAID5 source code by putting some printk () statemen=
ts
inside the raid5.c file.

But I am observing some strange behavior while working on this.

After putting some printk () statements inside raid5.c file my RAID5 ar=
ray
sometimes gets created successfully and sometimes kernel gets crashed b=
y
giving kernel oops.

Is the 2.6.15 RAID5 with bitmap support is stable?

# cat /proc/mdstat shows
Personalities : [raid5]
md0 : active raid5 sdd1[4] sdc1[2] sdb1[1] sda1[0]
=A0=A0=A0=A0=A0 60243456 blocks level 5, 64k chunk, algorithm 2 [4/3] [=
UUU_]
=A0=A0=A0=A0=A0 [>....................]=A0 recovery =3D=A0 2.9% (589440=
/20081152)
finish=3D563.5min speed=3D574K/sec
=A0=A0=A0=A0=A0 bitmap: 0/10 pages [0KB], 1024KB chunk, file: /home/bit=
map

Do I will have to do I/O=92s only after the RAID5 MD array gets initial=
ized?
Or Am I able to do I/O=92s while RAID5 is in initialized state as shown=
 by cat
/proc/mdstat?

Looking forward to your valuable suggestions.

Thanks,
Yogesh Pahilwan




-----------------------------------------------------------
Yogesh Pahilwan
Software Engineer
-----------------------------------------------------------
S P Software Technologies (I) Pvt. Ltd.
(ISO 9001:2000 Company)
=91Parthsarathi=92, S. No. 12/6, Kothrud,
Pune - 411 038. Maharashtra,
INDIA
-----------------------------------------------------------
Tel #=A0 : + 91 =96 020 =96 56006983 / 56007503 / 56006154
=46ax # : + 91 =96 020 =96 25411295
-----------------------------------------------------------
Visit us at: www.spsoftindia.com
-----------------------------------------------------------



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
