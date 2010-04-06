From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Update: mdadm 3.1.1 / 2.6.32 - trouble reducing active devices in
	13TB RAID6
Date: Mon, 5 Apr 2010 17:07:28 -0700
Message-ID: <j2p4877c76c1004051707z7c42502fr629d3e3156d7ea44@mail.gmail.com>
References: <n2j8cf253381004040015ga48536b2s204f3b622367b06a@mail.gmail.com>
	 <m2i8cf253381004051610s9079ef8du63711ba580f0fed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m2i8cf253381004051610s9079ef8du63711ba580f0fed@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brett King <king.br@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 5, 2010 at 4:10 PM, Brett King <king.br@gmail.com> wrote:
> Another update: things didn't quite go as planned .. the reshape
> didn't quite finish - it got to 99.9% and stopped there:
>
> md0 : active raid6 sdq[0] sdc[12] sdb[11] sda[10] sdo[9] sdn[8] sdm[7=
]
> sdl[6] sdv[5] sdu[4] sdd[3] sds[2] sdr[1]
> =A0 =A0 =A09767624960 blocks super 0.91 level 6, 64k chunk, algorithm=
 2
> [12/12] [UUUUUUUUUUUU]
> =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
>.] =A0reshape =3D 99.9% (976761856/976762496)
> finish=3D0.0min speed=3D4K/sec
>
> I left it overnight hence the low speed average. A stop and restart
> using the backup-file also didn't end well:
>
> array:/tmp/mdadm-3.1.2 # ./mdadm -S /dev/md0
> mdadm: stopped /dev/md0
> array:/tmp/mdadm-3.1.2 # ./mdadm -A /dev/md0 --backup-file /export/md=
0-backup
> mdadm: Failed to restore critical section for reshape, sorry.
>
> (the backup-file isn't on the array being reshaped).
>
> Looks like the code's almost there but not quite .. there are 640
> remaining blocks.
>
> array:/tmp/mdadm-3.1.2 # uname -a
> Linux array 2.6.34-rc3-7-default #1 SMP 2010-03-31 17:12:53 +0200
> x86_64 x86_64 x86_64 GNU/Linux
> array:/tmp/mdadm-3.1.2 # ./mdadm -V
> mdadm - v3.1.2 - 10th March 2010
> array:/tmp/mdadm-3.1.2 #
>
> Any ideas ?
>
> Cheers,
> Brett.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Anything useful/interesting in the dmesg output?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
