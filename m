From: Hank Barta <hbarta@gmail.com>
Subject: Re: RAID5 hangs on startup when 1 of 5 drives is disconnected.
Date: Tue, 5 Oct 2010 08:00:17 -0500
Message-ID: <AANLkTinQ_3-XMs=UemyeDMZ0CVB9s5autqJmO3fo5X1B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 4, 2010 at 2:46 PM, Hank Barta <hbarta@gmail.com> wrote:
>
> Raid status:
> hbarta@oak:~$ cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active raid5 sdd1[1] sdf1[3] sde1[2] sdc1[0] sdb1[4]
> =A0 =A0 =A0781433344 blocks level 5, 32k chunk, algorithm 2 [5/5] [UU=
UUU]
> unused devices: <none>
> hbarta@oak:~$

I saw this in another message and thought the information might be usef=
ul here:
hbarta@oak:~$ sudo mdadm --detail --scan
ARRAY /dev/md0 level=3Draid5 num-devices=3D5 metadata=3D00.90
UUID=3Da7cc80af:206de849:dd30336a:6ea23e69
hbarta@oak:~$

(I have also corrected a typo in the subject line. RAID1 should say RAI=
D5)

thanks,
hank

--=20
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
