From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid1 oops, 2.6.16
Date: Fri, 18 Aug 2006 13:05:30 -0400
Message-ID: <44E5F35A.8020707@steeleye.com>
References: <eb28go$vl2$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eb28go$vl2$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Lunz <lunz@falooley.org>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jason Lunz wrote:
> I just had a disk die in a 2.6.16 (debian kernel) raid1 server, and it's
> triggered an oops in raid1.

We just saw this problem as well, on SUSE 2.6.16.21-0.8. However, it 
looks like the problem code still exists in at least 2.6.18-rc1, and I 
haven't seen any patches recently that would have fixed it, so I believe 
this is still a problem. Details and possible fix below.


> RAID1 conf printout:
>  --- wd:1 rd:2
>  disk 1, wo:0, o:1, dev:hda1
> Unable to handle kernel NULL pointer dereference at virtual address 00000088
>  printing eip:
> f0831ea8
> *pde = 00000000
> Oops: 0002 [#1]
> Modules linked in: thermal fan button processor ac battery e1000 rtc ext3 jbd mbcache raid1 md_mod ide_disk generic siimage ide_core evdev mousedev
> CPU:    0
> EIP:    0060:[<f0831ea8>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.16-2-686 #1)
> EIP is at raid1d+0x2c8/0x4c3 [raid1]
> eax: 00000008   ebx: 00000000   ecx: c9c60100   edx: b1a1ac60
> esi: 00000000   edi: dd67c6c0   ebp: efd52740   esp: b1ac1f08
> ds: 007b   es: 007b   ss: 0068
> Process md5_raid1 (pid: 1001, threadinfo=b1ac0000 task=b1bc5a70)
> Stack: <0>000000b1 5e341300 003e0387 00000001 00000001 00000008 00000008 025e1458
>        00000000 b1bc5b98 00000001 efd5275c b1ac1fa4 7fffffff b026e32b 00000005
>        b1ac0000 b1ac1f84 7fffffff 00000000 b1a1aba0 b1ac1f84 b1ac1fa4 7fffffff
> Call Trace:
>  [<b026e32b>] schedule_timeout+0x13/0x8e
>  [<f0864095>] md_thread+0xe3/0xfb [md_mod]
>  [<b012522e>] autoremove_wake_function+0x0/0x3a
>  [<b026dced>] schedule+0x45f/0x4cd
>  [<b012522e>] autoremove_wake_function+0x0/0x3a
>  [<f0863fb2>] md_thread+0x0/0xfb [md_mod]
>  [<b0124efe>] kthread+0x79/0xa3
>  [<b0124e85>] kthread+0x0/0xa3
>  [<b01012cd>] kernel_thread_helper+0x5/0xb
> Code: 83 7c 24 10 00 8b 47 20 0f 84 dc 00 00 00 89 74 24 0c 39 c6 74 63 85 f6 75 03 8b 75
> 08 4e 8b 55 04 6b c6 0c 8b 1c 02 8b 44 24 14 <01> 83 88 00 00 00 85 db 74 3f 8b 43 70 a8 04 74 38 6a 01 ff 75
>  end_request: I/O error, dev hdc, sector 26464418



We had one of our Fiber arrays hang and I/O started failing:

Aug 17 23:14:44 tristan kernel: raid1: cciss/c1d1p1: rescheduling sector 
466400
Aug 17 23:14:44 tristan kernel: cciss: cmd df340000 timedout
Aug 17 23:14:44 tristan kernel: raid1: cciss/c1d2p1: rescheduling sector 
1264808
Aug 17 23:14:45 tristan kernel: cciss: cmd df340250 timedout
Aug 17 23:14:45 tristan kernel: raid1: cciss/c1d3p1: rescheduling sector 
1459712
Aug 17 23:14:45 tristan kernel: cciss: cmd df3404a0 timedout
Aug 17 23:14:45 tristan kernel: raid1: cciss/c1d4p1: rescheduling sector 
1378648
Aug 17 23:14:46 tristan kernel: cciss: cmd df340b90 timedout
Aug 17 23:14:46 tristan kernel: raid1: Disk failure on cciss/c1d2p1, 
disabling device.
Aug 17 23:14:46 tristan kernel: 	Operation continuing on 1 devices
Aug 17 23:14:46 tristan kernel: RAID1 conf printout:
Aug 17 23:14:46 tristan kernel:  --- wd:1 rd:2
Aug 17 23:14:46 tristan kernel:  disk 0, wo:0, o:1, dev:sdc1
Aug 17 23:14:46 tristan kernel:  disk 1, wo:1, o:0, dev:cciss/c1d2p1
Aug 17 23:14:46 tristan kernel: RAID1 conf printout:
Aug 17 23:14:46 tristan kernel:  --- wd:1 rd:2
Aug 17 23:14:46 tristan kernel:  disk 0, wo:0, o:1, dev:sdc1

^^^^ The disk got kicked from the array.

Aug 17 23:14:46 tristan kernel: Unable to handle kernel NULL pointer 
dereference at virtual address 00000088
Aug 17 23:14:46 tristan kernel:  printing eip:
Aug 17 23:14:46 tristan kernel: e0c35105
Aug 17 23:14:46 tristan kernel: *pde = 00000000
Aug 17 23:14:46 tristan kernel: Oops: 0002 [#1]
Aug 17 23:14:46 tristan kernel: SMP
Aug 17 23:14:46 tristan kernel: last sysfs file: /block/sdd/sdd1/size
Aug 17 23:14:46 tristan kernel: Modules linked in: ext3 jbd raid1 ipv6 
dm_multipath button battery ac apparmor aamatch_pcre loop dm_mod 
sworks_agp agpgart ide_cd cpqphp cdrom i2c_piix4 i2c_core tg3 
pci_hotplug reiserfs edd fan thermal processor sg qla2xxx firmware_class 
scsi_transport_fc cciss serverworks sd_mod scsi_mod ide_disk ide_core
Aug 17 23:14:46 tristan kernel: CPU:    0
Aug 17 23:14:47 tristan kernel: EIP:    0060:[<e0c35105>]    Tainted: GF 
    U VLI
Aug 17 23:14:47 tristan kernel: EFLAGS: 00010286   (2.6.16.21-0.8-smp #1)
Aug 17 23:14:47 tristan kernel: EIP is at raid1d+0x8e0/0xb95 [raid1]
Aug 17 23:14:47 tristan kernel: eax: 00000008   ebx: 00000000   ecx: 
d06f0840   edx: d06f0840
Aug 17 23:14:47 tristan kernel: esi: 00000000   edi: 00000001   ebp: 
00001000   esp: cf095ed4
Aug 17 23:14:47 tristan kernel: ds: 007b   es: 007b   ss: 0068
Aug 17 23:14:47 tristan kernel: Process md1_raid1 (pid: 9332, 
threadinfo=cf094000 task=de0d3050)
Aug 17 23:14:47 tristan kernel: Stack: <0>dfd00cd0 c1411b80 df067a00 
c48d1240 d06f0840 d06f0860 00000001 00134ca8
Aug 17 23:14:47 tristan kernel:        00000000 00000060 00000008 
00000000 c0340b08 0000000a de0d318c de0d3050
Aug 17 23:14:47 tristan kernel:        dfd00af0 c1414da0 d4f08a9c 
0000011d 00005fea 00000002 c0340b28 0000000a
Aug 17 23:14:47 tristan kernel: Call Trace:
Aug 17 23:14:47 tristan kernel:  [<c011a067>] default_wake_function+0x0/0xc
Aug 17 23:14:47 tristan kernel:  [<c028fa0f>] schedule_timeout+0x13/0x8e
Aug 17 23:14:47 tristan kernel:  [<c022fc7a>] md_thread+0xed/0x104
Aug 17 23:14:47 tristan kernel:  [<c0130977>] 
autoremove_wake_function+0x0/0x2d
Aug 17 23:14:47 tristan kernel:  [<c022fb8d>] md_thread+0x0/0x104
Aug 17 23:14:47 tristan kernel:  [<c0130895>] kthread+0x9d/0xc9
Aug 17 23:14:47 tristan kernel:  [<c01307f8>] kthread+0x0/0xc9
Aug 17 23:14:47 tristan kernel:  [<c0102005>] kernel_thread_helper+0x5/0xb
Aug 17 23:14:47 tristan kernel: Code: 8b 44 24 0c 3b 70 20 0f 84 d5 00 
00 00 eb 95 85 ff 75 07 8b 54 24 10 8b 7a 08 8b 4c 24 10 4f 6b c7 0c 03 
41 04 8b 18 8b 44 24 28 <f0> 01 83 88 00 00 00 85 db 74 41 8b 43 70 a8 
04 74 3a 8b 53 18


 From the objdump of raid1.ko for this kernel, the oops occurred here 
(at raid1d+0x8e0):

     20eb:       75 07                   jne    20f4 <raid1d+0x8cf>
     20ed:       8b 54 24 10             mov    0x10(%esp),%edx
     20f1:       8b 7a 08                mov    0x8(%edx),%edi
     20f4:       8b 4c 24 10             mov    0x10(%esp),%ecx
     20f8:       4f                      dec    %edi
     20f9:       6b c7 0c                imul   $0xc,%edi,%eax
     20fc:       03 41 04                add    0x4(%ecx),%eax
     20ff:       8b 18                   mov    (%eax),%ebx
     2101:       8b 44 24 28             mov    0x28(%esp),%eax
     2105:       f0 01 83 88 00 00 00    lock add %eax,0x88(%ebx)
^^^^^^^^
     210c:       85 db                   test   %ebx,%ebx
     210e:       74 41                   je     2151 <raid1d+0x92c>
     2110:       8b 43 70                mov    0x70(%ebx),%eax
     2113:       a8 04                   test   $0x4,%al
     2115:       74 3a                   je     2151 <raid1d+0x92c>
     2117:       8b 53 18                mov    0x18(%ebx),%edx
     211a:       8b 4c 24 20             mov    0x20(%esp),%ecx
     211e:       89 54 24 04             mov    %edx,0x4(%esp)

The "lock add" is an atomic_add, of which there is exactly one in raid1d 
(line 1491, raid1.c):

                 if (success) {
                          /* write it back and re-read */
                          int start = d;
                          while (d != r1_bio->read_disk) {
                                 if (d==0)
                                         d = conf->raid_disks;
                                 d--;
                                 rdev = conf->mirrors[d].rdev;
                                 atomic_add(s, &rdev->corrected_errors);
                                 if (rdev &&
                                     test_bit(In_sync, &rdev->flags)) {
                                         if (sync_page_io(rdev->bdev,
                                             sect + rdev->data_offset,
                                             s<<9, conf->tmppage, WRITE) 
== 0)
                                          /* Well, this device is dead */
                                          md_error(mddev, rdev);
                          }
                 }


This is where raid1d is retrying read errors, and trying to rewrite the 
data using data it read from a working disk in the array, so that 
matches up with what was going on at the time on this system. The offset 
of 0x88 (where the NULL pointer exception occurred) matches the offset 
of rdev->corrected_errors, and this makes sense since md just kicked the 
failing drive (each drive has an rdev structure) from the array.

The atomic_add (and any other access to an rdev, for that matter) needs 
to be guarded by a NULL check, I think.

Neil, does that sound right?

-- 
Paul
