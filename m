From: Andreas-Sokov <andre.s@j8.com.ru>
Subject: Re[2]: mdadm 2.6.4 : How i can check out current status of reshaping ?
Date: Tue, 5 Feb 2008 12:13:32 +0300
Message-ID: <58351009.20080205121332@j8.com.ru>
References: <79188012.20080204070802@j8.com.ru>
 <18343.38465.112723.66522@notabene.brown>
Reply-To: Andreas-Sokov <andre.s@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18343.38465.112723.66522@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Neil.

YOU WROTE : 5 =F4=E5=E2=F0=E0=EB=FF 2008 =E3., 01:48:33:
> On Monday February 4, andre.s@j8.com.ru wrote:
>>=20
>> root@raid01:/# cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [r=
aid4] [multipath] [faulty]
>> md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
>>       1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [=
5/4] [UUUU_]
>>=20
>> unused devices: <none>
>>=20
>> ####################################################################=
##########
>> But how i can see the status of reshaping ?
>> Is it reshaped realy ? or may be just hang up ? or may be mdadm noth=
ing do not give in
>> general ?
>> How long wait when reshaping will finish ?
>> ####################################################################=
##########
>>=20

> The reshape hasn't restarted.

> Did you do that "mdadm -w /dev/md1" like I suggested?  If so, what
> happened?

> Possibly you tried mounting the filesystem before trying the "mdadm
> -w".  There seems to be a bug such that doing this would cause the
> reshape not to restart, and "mdadm -w" would not help any more.

> I suggest you:

>   echo 0 > /sys/module/md_mod/parameters/start_ro

> stop the array=20
>   mdadm -S /dev/md1
> (after unmounting if necessary).

> Then assemble the array again.
> Then
>   mdadm -w /dev/md1

> just to be sure.

> If this doesn't work, please report exactly what you did, exactly wha=
t
> message you got and exactly where message appeared in the kernel log.

> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I read again your latter.
at first time i did not do

echo 0 > /sys/module/md_mod/parameters/start_ro

now i have done this, then
mdadm -S /dev/md1
mdadm /dev/md1 -A /dev/sd[bcdef]
mdadm -w /dev/md1

and i have : after 2 minutes kernel show something
but reshaping during in process still

root@raid01:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4] [multipath] [faulty]
md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
      1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4=
] [UUUU_]
      [=3D=3D>..................]  reshape =3D 10.1% (49591552/48838649=
6) finish=3D12127.2min speed=3D602K/sec

unused devices: <none>
root@raid01:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4] [multipath] [faulty]
md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
      1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4=
] [UUUU_]
      [=3D=3D>..................]  reshape =3D 10.1% (49591552/48838649=
6) finish=3D12259.0min speed=3D596K/sec

unused devices: <none>
root@raid01:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4] [multipath] [faulty]
md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
      1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4=
] [UUUU_]
      [=3D=3D>..................]  reshape =3D 10.1% (49591552/48838649=
6) finish=3D12311.7min speed=3D593K/sec

unused devices: <none>
root@raid01:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4] [multipath] [faulty]
md1 : active raid5 sdc[0] sdb[5](S) sdf[3] sde[2] sdd[1]
      1465159488 blocks super 0.91 level 5, 64k chunk, algorithm 2 [5/4=
] [UUUU_]
      [=3D=3D>..................]  reshape =3D 10.1% (49591552/48838649=
6) finish=3D12338.1min speed=3D592K/sec

unused devices: <none>




=46eb  5 11:54:21 raid01 kernel: raid5: reshape will continue
=46eb  5 11:54:21 raid01 kernel: raid5: device sdc operational as raid =
disk 0
=46eb  5 11:54:21 raid01 kernel: raid5: device sdf operational as raid =
disk 3
=46eb  5 11:54:21 raid01 kernel: raid5: device sde operational as raid =
disk 2
=46eb  5 11:54:21 raid01 kernel: raid5: device sdd operational as raid =
disk 1
=46eb  5 11:54:21 raid01 kernel: raid5: allocated 5245kB for md1
=46eb  5 11:54:21 raid01 kernel: raid5: raid level 5 set md1 active wit=
h 4 out of 5 devices, algorithm 2
=46eb  5 11:54:21 raid01 kernel: RAID5 conf printout:
=46eb  5 11:54:21 raid01 kernel:  --- rd:5 wd:4
=46eb  5 11:54:21 raid01 kernel:  disk 0, o:1, dev:sdc
=46eb  5 11:54:21 raid01 kernel:  disk 1, o:1, dev:sdd
=46eb  5 11:54:21 raid01 kernel:  disk 2, o:1, dev:sde
=46eb  5 11:54:21 raid01 kernel:  disk 3, o:1, dev:sdf
=46eb  5 11:54:21 raid01 kernel: ...ok start reshape thread
=46eb  5 11:54:21 raid01 mdadm: RebuildStarted event detected on md dev=
ice /dev/md1
=46eb  5 11:54:21 raid01 kernel: md: reshape of RAID array md1
=46eb  5 11:54:21 raid01 kernel: md: minimum _guaranteed_  speed: 1000 =
KB/sec/disk.
=46eb  5 11:54:21 raid01 kernel: md: using maximum available idle IO ba=
ndwidth (but not more than 200000 KB/sec) for reshape.
=46eb  5 11:54:21 raid01 kernel: md: using 128k window, over a total of=
 488386496 blocks.
=46eb  5 11:56:12 raid01 kernel: BUG: unable to handle kernel paging re=
quest at virtual address 001cd901
=46eb  5 11:56:12 raid01 kernel:  printing eip:
=46eb  5 11:56:12 raid01 kernel: c041c374
=46eb  5 11:56:12 raid01 kernel: *pde =3D 00000000
=46eb  5 11:56:12 raid01 kernel: Oops: 0002 [#1]
=46eb  5 11:56:12 raid01 kernel: SMP
=46eb  5 11:56:12 raid01 kernel: Modules linked in: nfsd exportfs lockd=
 nfs_acl sunrpc ipt_LOG xt_tcpudp nf_conntrack_ipv4 xt_state nf_conntra=
ck nfnetlink iptable_filter ip_tables x_tables button ac battery loop t=
sdev psmouse iTCO_wdt sk98lin serio_raw intel_agp agpgart evdev shpchp =
pci_hotplug pcspkr rtc ide_cd cdrom ide_disk ata_piix piix e1000 generi=
c ide_core sata_mv uhci_hcd ehci_hcd usbcore thermal processor fan
=46eb  5 11:56:12 raid01 kernel: CPU:    1
=46eb  5 11:56:12 raid01 kernel: EIP:    0060:[<c041c374>]    Not taint=
ed VLI
=46eb  5 11:56:12 raid01 kernel: EFLAGS: 00010202   (2.6.22.16-6 #7)
=46eb  5 11:56:12 raid01 kernel: EIP is at md_do_sync+0x629/0xa32
=46eb  5 11:56:12 raid01 kernel: eax: 001cd901   ebx: c0410d1b   ecx: 0=
0000080   edx: 00000000
=46eb  5 11:56:12 raid01 kernel: esi: 05e96a00   edi: 00000000   ebp: d=
ff3e400   esp: f796beb4
=46eb  5 11:56:12 raid01 kernel: ds: 007b   es: 007b   fs: 00d8  gs: 00=
00  ss: 0068
=46eb  5 11:56:12 raid01 kernel: Process md1_reshape (pid: 3759, ti=3Df=
796a000 task=3Df7e8a550 task.ti=3Df796a000)
=46eb  5 11:56:12 raid01 kernel: Stack: f796bf9c 00000000 1d1c2fc0 0000=
0000 00000500 00000000 f796bf88 dff3e410
=46eb  5 11:56:12 raid01 kernel:        9ac41500 06000000 6a922c00 1d1c=
2fc0 00000000 dff3e400 000020d2 3a385f80
=46eb  5 11:56:12 raid01 kernel:        00000000 001cd800 00000000 0000=
0006 001cd700 00000000 c056fb6b 00177900
=46eb  5 11:56:12 raid01 kernel: Call Trace:
=46eb  5 11:56:12 raid01 kernel:  [<c041e8ee>] md_thread+0xcc/0xe3
=46eb  5 11:56:12 raid01 kernel:  [<c011b368>] complete+0x39/0x48
=46eb  5 11:56:12 raid01 kernel:  [<c041e822>] md_thread+0x0/0xe3
=46eb  5 11:56:12 raid01 kernel:  [<c0131b89>] kthread+0x38/0x5f
=46eb  5 11:56:12 raid01 kernel:  [<c0131b51>] kthread+0x0/0x5f
=46eb  5 11:56:12 raid01 kernel:  [<c0104947>] kernel_thread_helper+0x7=
/0x10
=46eb  5 11:56:12 raid01 kernel:  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=46eb  5 11:56:12 raid01 kernel: Code: 54 24 48 0f 87 a4 01 00 00 72 0a=
 3b 44 24 44 0f 87 98 01 00 00 3b 7c 24 40 75 0a 3b 74 24 3c 0f 84 88 0=
1 00 00 0b 85 30 01 00 00 <88> 08 0f 85 90 01 00 00 8b 85 30 01 00 00 a=
8 04 0f 85 82 01 00
=46eb  5 11:56:12 raid01 kernel: EIP: [<c041c374>] md_do_sync+0x629/0xa=
32 SS:ESP 0068:f796beb4







--=20
Best regards,
Andreas-Sokov

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
