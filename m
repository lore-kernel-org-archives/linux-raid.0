From: Jeff W <jeff.welling@gmail.com>
Subject: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 15:28:02 -0500
Message-ID: <CAKXovcuov4LaW4EXaZsE-QgOmrXx0kFu5ykno=_1q-TcK1kQPw@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
	<CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
	<CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
	<CAK2H+eds+2wu6Nep639mZ1dkOMmxdzqp4_7-o=QJO_qqcTWr9g@mail.gmail.com>
	<CAKXovctDA28Gk61EJF_1-6kX2kMwRG8yyza4VFsKpzwsiHOEGQ@mail.gmail.com>
	<CAK2H+ee3ERstCsh4ju9kfU0gpFenHqUuMdtjnhFthK8C--NoXw@mail.gmail.com>
	<CAKXovcs-UORdS6d8XYuDa=CF2rMX8H+PX2Y_Gh5N2Oze8Ni+-A@mail.gmail.com>
	<CAK2H+efLnZTvAFcCN=2GTJo6FErFhm330xG6tPNFNxs=5gOPSA@mail.gmail.com>
	<CAKXovcuCz9UZrk8+hMsJ_zuST2ZqZBtzhBYewX7ZXA2chruHKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKXovcuCz9UZrk8+hMsJ_zuST2ZqZBtzhBYewX7ZXA2chruHKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So what _actually_ happens when you issue the commands? Please post
> back the results of
>
> cat /proc/mdstat

jeff@Shmee:~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active raid6 sda[0] sdf1[1] sdg1[5] sde[4] sdd1[3] sdc1[2]
=A0 =A0 =A02441437440 blocks level 6, 64k chunk, algorithm 2 [7/6] [UUU=
UUU_]

unused devices: <none>


>
> and
>
> mount /dev/mdWHATEVER /mountpoint

jeff@Shmee:~$ sudo mount /dev/md1 /mnt
[sudo] password for jeff:
mount: wrong fs type, bad option, bad superblock on /dev/md1,
=A0 =A0 =A0 missing codepage or helper program, or other error
=A0 =A0 =A0 In some cases useful info is found in syslog - try
=A0 =A0 =A0 dmesg | tail =A0or so


jeff@Shmee:~$ dmesg | tail
[48532.584428] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
encoder (output 0)
[49369.880015] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
encoder (output 0)
[50470.240278] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
encoder (output 0)
[50522.284317] usb 2-6: USB disconnect, address 4
[52848.285524] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
encoder (output 0)
[52940.534516] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
encoder (output 0)
[53540.724023] [drm] nouveau 0000:01:00.0: Setting dpms mode 1 on vga
encoder (output 0)
[54039.813485] [drm] nouveau 0000:01:00.0: Setting dpms mode 0 on vga
encoder (output 0)
[58210.212241] EXT3-fs error (device md1): ext3_check_descriptors:
Block bitmap for group 6016 not in group (block 277891307)!
[58210.247230] EXT3-fs: group descriptors corrupted!

Is that more helpful?
Thanks!
Jeff.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
