From: Bryan Bush <bbushvt@gmail.com>
Subject: Re: RAID6 grow failed
Date: Sun, 1 Apr 2012 20:02:57 -0400
Message-ID: <CAJ72viOU2O-1rsaJWKbDbR6XS+VYfDuWa8DpN=+w-1BYp7fwNA@mail.gmail.com>
References: <CAJ72viP2MLb2tL84P-aK6Rs9eAH4x9Wwd=kVNbmPA=2LAfNLjg@mail.gmail.com>
	<20120328151828.6988d3db@notabene.brown>
	<CAJ72viMxgfjhQiqJYVnjBQGfCq7jtegfvUY0nRdj46XDedeSjg@mail.gmail.com>
	<20120328192601.3db82133@notabene.brown>
	<CAJ72viPX1SDL2pPSkGQnujNcaoNmRposJXxaLhDkZDgFxv=-qA@mail.gmail.com>
	<CAJ72viPH9AykY-tafTChcS0ZbP0gGaiKRybafs4C4Yk-8D=g3A@mail.gmail.com>
	<20120401080036.355a8a23@notabene.brown>
	<CAJ72viOGCYrMqvX2=3BzWQZpfDUeNwHEVHbXyaKbrwvrBP6wPQ@mail.gmail.com>
	<CAJ72viPw=QrETGPU5OwBgL-GXfCUfqfbWCSAvp2_yzzxuJeT1w@mail.gmail.com>
	<20120402095425.168e5d94@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120402095425.168e5d94@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

root@diamond:/# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdk1[13](S) sdj1[11](S) sdh1[9](S) sdo1[3](S)
sdd1[6](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdb1[4](S) sdc1[8](S)
      19535134315 blocks super 1.2

md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
      2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
root@diamond:/# mdadm -S /dev/md1
mdadm: stopped /dev/md1
root@diamond:/# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
      2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
root@diamond:/# mdadm -A --verbose /dev/md1 /dev/sd[onjlkuhedcb]1
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
mdadm: device 8 in /dev/md1 has wrong state in superblock, but
/dev/sdk1 seems ok
mdadm: device 10 in /dev/md1 has wrong state in superblock, but
/dev/sdj1 seems ok
mdadm: device 12 in /dev/md1 has wrong state in superblock, but
/dev/sdh1 seems ok
mdadm: SET_ARRAY_INFO failed for /dev/md1: Device or resource busy
root@diamond:/# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdk1[13](S) sdj1[11](S) sdd1[6](S) sdh1[9](S)
sdo1[3](S) sde1[7](S) sdn1[2](S) sdl1[0](S) sdc1[8](S) sdb1[4](S)
      19535134315 blocks super 1.2

md0 : active raid5 sdg1[3] sda1[0] sdf1[1] sdq1[2]
      2929686528 blocks level 5, 256k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>


Output from /var/log/messages for the mdadm -A
Apr  1 20:00:57 diamond kernel: [106978.432900] md: md1 stopped.
Apr  1 20:00:57 diamond kernel: [106978.493151] md: bind<sdc1>
Apr  1 20:00:57 diamond kernel: [106978.494551] md: bind<sdb1>
Apr  1 20:00:57 diamond kernel: [106978.496256] md: bind<sdd1>
Apr  1 20:00:57 diamond kernel: [106978.516939] md: array md1 already h=
as disks!
Apr  1 20:00:57 diamond kernel: [106978.525475] md: bind<sdo1>
Apr  1 20:00:57 diamond kernel: [106978.527509] md: bind<sdn1>
Apr  1 20:00:58 diamond kernel: [106978.694915] md: bind<sde1>
Apr  1 20:00:58 diamond kernel: [106978.726157] md: bind<sdl1>
Apr  1 20:00:58 diamond kernel: [106978.868815] md: bind<sdh1>
Apr  1 20:00:58 diamond kernel: [106979.079319] md: bind<sdj1>
Apr  1 20:00:58 diamond kernel: [106979.280302] md: bind<sdk1>


Thanks
-Bryan



On Sun, Apr 1, 2012 at 7:54 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 1 Apr 2012 03:05:29 -0400 Bryan Bush <bbushvt@gmail.com> wrot=
e:
>
>> Additional info that might be useful. =A0When I specify which disks =
to
>> use in the array, I get this
>> root@diamond:/# mdadm -A --verbose /dev/md1 /dev/sd[onjlkuhedcb]1
>> mdadm: looking for devices for /dev/md1
>> mdadm: /dev/sdb1 is identified as a member of /dev/md1, slot 4.
>> mdadm: /dev/sdc1 is identified as a member of /dev/md1, slot 5.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md1, slot 6.
>> mdadm: /dev/sde1 is identified as a member of /dev/md1, slot 7.
>> mdadm: /dev/sdh1 is identified as a member of /dev/md1, slot 12.
>> mdadm: /dev/sdj1 is identified as a member of /dev/md1, slot 10.
>> mdadm: /dev/sdk1 is identified as a member of /dev/md1, slot 8.
>> mdadm: /dev/sdl1 is identified as a member of /dev/md1, slot 0.
>> mdadm: /dev/sdn1 is identified as a member of /dev/md1, slot 2.
>> mdadm: /dev/sdo1 is identified as a member of /dev/md1, slot 3.
>> mdadm: device 8 in /dev/md1 has wrong state in superblock, but
>> /dev/sdk1 seems ok
>> mdadm: device 10 in /dev/md1 has wrong state in superblock, but
>> /dev/sdj1 seems ok
>> mdadm: device 12 in /dev/md1 has wrong state in superblock, but
>> /dev/sdh1 seems ok
>> mdadm: SET_ARRAY_INFO failed for /dev/md1: Device or resource busy
>> root@diamond:/#
>
> 1/ Are you absolutely certain you did
> =A0 =A0 mdadm -S /dev/md1
> =A0first? =A0Because it really looks like you didn't.
>
> 2/ Any kernel log messages?
> =A0 =A0dmesg | tail -n 50
> =A0immediately after the failed "mdadm -A" command.
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
