From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 11:35:06 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNACEOIDAAA.kc130iseo@coastalnet.com>
References: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NDBBIAKEEKGGEIKCBKNAAEOGDAAA.kc130iseo@coastalnet.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Cal Webster
> Sent: Wednesday, June 26, 2002 10:41 AM
> To: linux-raid@vger.kernel.org
> Subject: raidreconf: Successful RAID5 Reconstruction (re-size)
>

I spoke too soon!

Although there were no indications of errors and initial indications were
promising, deeper investigation revealed that the data (or at least the
directories) have been corrupted.

When attempting to re-mount iso images located on the RAID device, I got
"Not a directory" errors.

A listing at the top level of the mounted RAID5 device shows a somewhat
garbled directory:

[root@winggear archive]# df -k
Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/hda5              1008952    149796    807904  16% /
/dev/hda2             25134948  11767212  12090936  50% /home
/dev/hda1             25134948   2299120  21559028  10% /usr
/dev/hda4             25136164  18782060   5077244  79% /var
/dev/md0              69616104  37240476  28839296  57% /usr/local/archive

[root@winggear root]# cd /usr/local/archive/

[root@winggear archive]# ls -l
total 16
?-wSrwxr-T  38216 843638119 136403541 3092718354 May 21  1957 backup
sr-x--S--t  62581 1917696496 1424539385 3344111388 Nov 13  1975 iso
drwxr-xr-x    2 root     root        16384 Apr 26  2001 lost+found
b--Sr-xrw-  24320 1593859840 1902061873  44,  49 Jul  8  2002 shares

There should be four normal directory entries here.

Anyone know what could have caused this?

--Cal Webster

