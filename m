From: Louis-David Mitterrand <vindex@apartia.org>
Subject: repeatable crash during raid5 rebuild on 2.4.19-smp
Date: Sun, 6 Oct 2002 12:16:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021006101636.GA29381@apartia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Yesterday when I entered the server room at 1600 I thought I'd be out b=
y
1800, with the intention of adding a Fujitsu MAM3367MP (15krpm 36G) to
a raid1 array and converting it to raid5.

I did the following:

- halt machine (dell Poweredge 1400 dual 1Ghz), add third drive
- reboot with root=3D/dev/sda1 instead of root=3D/dev/md0 to have 2 fre=
e
  drives out of 3 to build a degraded raid5 array,
- create /dev/md0 (small raid1 boot partition), /dev/md1 (raid5 root),
  /dev/md2 (raid5 swap) with /dev/sdb (former /dev/sda mirror) and
  /dev/sdc (new identical drive),
- switch to runlevel 1, copy / (/dev/sda1) to /mnt (/dev/md1)
- adjust /mnt/etc/fstab to mount /dev/md1 as root and /dev/md2 as swap
- reboot with root=3D/dev/md1
- all is well, cat /proc/mdstat shows /dev/md[012] are working fine in
  degraded mode,=20
- /dev/sda is partitioned identically to /dev/sd[bc]
- final steps:=20
	- "mdadm /dev/md0 --add /dev/sda1" goes OK
	- "mdadm /dev/md1 --add /dev/sda2" starts OK, says 15 minutes to go,
	  when at 25% rebuild suddenly it stops with "md_do_sync() caught
	  signal, exiting"

Now the machine is hung, I can switch virtual consoles but can't login.
No disk activity. I hit the reset button and on reboot /dev/md1 won't
start. I tried the multiple disk failure recovery from the howto withou=
t
success: no filesystem identified on the partition.

To make sure I retried all these steps three times with always the same
result: the array resync stops at 25%, the machine hangs and the array
won't come back on-line.

Is there a known issue with 2.4.19-smp and raid5? Did I hit a bug or is
the problem somewhere in my hardware.=20

The exact same procedure on a uniprocessor 2.4.19 with 3 IDE drives
worked fine.

I can provide more details if needed. I'd really like to understand wha=
t
happened there.

In the end I exited the server room around 0130 sunday morning after
recovering the machine from backup.

Cheers,

--=20
    PHEDRE: Malheureuse ! Voil=E0 comme tu m'as perdue.
            Au jour que je fuyais c'est toi qui m'as rendue.
                                          (Ph=E8dre, J-B Racine, acte 4=
, sc=E8ne 6)
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
