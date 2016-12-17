From: PHP-Friends GmbH <gl@php-friends.de>
Subject: Linux software RAID becomes unresponsive after removing a disk from
 server
Date: Sat, 17 Dec 2016 02:23:41 +0100
Message-ID: <7b8b1130-e79b-efcd-0579-c4a349ec5814@php-friends.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone,

first of all: This is in fact a crossposting from serverfault 
(http://serverfault.com/questions/821195/linux-software-raid-becomes-unresponsive-after-removing-a-disk-from-server), 
as the user shodanshok recommended contacting this mailing list because 
to him this seems like a possible bug in the Linux RAID software. I want 
to add that I can provide more logs and information if they are needed, 
but as the text is already quite long I thought that would be enough for 
the moment.

I am running a CentOS 7 machine (standard kernel: 
3.10.0-327.36.3.el7.x86_64) with a software RAID-10 over 16x 1 TB SSDs 
(to be more precise, there are two RAID arrays on the disks; one of the 
arrays is providing the host's swap partition). Last week, a SSD failed:

13:18:07 kvm7 kernel: sd 1:0:2:0: attempting task abort! 
scmd(ffff887e57b916c0)
13:18:07 kvm7 kernel: sd 1:0:2:0: [sdk] CDB: Write(10) 2a 08 02 55 20 08 
00 00 01 00
13:18:07 kvm7 kernel: scsi target1:0:2: handle(0x000b), 
sas_address(0x4433221102000000), phy(2)
13:18:07 kvm7 kernel: scsi target1:0:2: 
enclosure_logical_id(0x500304801c14a001), slot(2)
13:18:10 kvm7 kernel: sd 1:0:2:0: task abort: SUCCESS scmd(ffff887e57b916c0)
13:18:11 kvm7 kernel: sd 1:0:2:0: [sdk] FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
13:18:11 kvm7 kernel: sd 1:0:2:0: [sdk] Sense Key : Not Ready [current]
13:18:11 kvm7 kernel: sd 1:0:2:0: [sdk] Add. Sense: Logical unit not 
ready, cause not reportable
13:18:11 kvm7 kernel: sd 1:0:2:0: [sdk] CDB: Write(10) 2a 08 02 55 20 08 
00 00 01 00
13:18:11 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 
39133192
13:18:11 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 
39133192
13:18:11 kvm7 kernel: md: super_written gets error=-5, uptodate=0
13:18:11 kvm7 kernel: md/raid10:md3: Disk failure on sdk3, disabling 
device.#012md/raid10:md3: Operation continuing on 15 devices.
13:19:27 kvm7 kernel: sd 1:0:2:0: device_blocked, handle(0x000b)
13:19:29 kvm7 kernel: sd 1:0:2:0: [sdk] Synchronizing SCSI cache
13:19:29 kvm7 kernel: md: md3 still in use.
13:19:29 kvm7 kernel: sd 1:0:2:0: [sdk] Synchronize Cache(10) failed: 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
13:19:29 kvm7 kernel: mpt3sas1: removing handle(0x000b), 
sas_addr(0x4433221102000000)
13:19:29 kvm7 kernel: md: md2 still in use.
13:19:29 kvm7 kernel: md/raid10:md2: Disk failure on sdk2, disabling 
device.#012md/raid10:md2: Operation continuing on 15 devices.
13:19:29 kvm7 kernel: md: unbind<sdk3>
13:19:29 kvm7 kernel: md: export_rdev(sdk3)
13:19:29 kvm7 kernel: md: unbind<sdk2>
13:19:29 kvm7 kernel: md: export_rdev(sdk2)

/proc/mdstat looked as expected (1 faulty member) and the VMs kept 
running without any problems.

md3 : active raid10 sdp3[15] sdb3[2] sdg3[12] sde3[8] sdn3[11] sdl3[7] 
sdm3[9] sdf3[10] sdi3[1] sdk3[5](F) sdc3[4] sdd3[6] sdh3[14] sdo3[13] 
sda3[0] sdj3[3]
   7844052992 blocks super 1.2 128K chunks 2 near-copies [16/15] 
[UUUUU_UUUUUUUUUU]

The SSD had to be temporarily replaced with a bigger SSD as no 1 TB SSD 
was available; so we did, started the rebuild and everything was fine. 
Today the "right" SSD arrived, so the datacenter technican just pulled 
the tray containing the mentioned SSD and the system became unresponsive 
within seconds. While the host was running fine on a seperated RAID 
array, the VMs were unable to perform I/O. The load increased to > 800. 
I was able to execute mdadm --detail /dev/md3 which showed a degraded 
(but active / clean) array, so from this point of view the system was 
absolutely fine. I tried to remove the faulty / missing drive from the 
array, which of course failed ("no such device"), and suddenly even 
mdadm --detail /dev/md3 didn't generate any output anymore, it simply 
stuck and I had to kill the SSH session to get out of this. After this, 
I decided to force a reboot as I didn't even know how to remove this 
faulty drive from the array - and everything came up correctly. Of 
course the RAID was still degraded and needed a resync, but apart from 
that: no problems.

I'm pretty sure that I should have removed the drive via mdadm after a 
--set-faulty before pulling the tray out of the rack, though I can't 
explain this behaviour of mdraid. In my opinion we "simulated" a regular 
disk outage, so has anybody an idea what caused this issue and how I can 
make sure, that the next regular disk outage won't cause the same problem?

The kernel logged some messages, and what I find interesting is that the 
new device came up as sdq while the pulled device was known as sdk. So I 
assume that sdk was not kicked correctly from the array. When the 
initial SSD failure happened last week, I didn't see this behaviour; so 
the replacement drive also came up as sdk.

The log also shows 7 minutes between the failure of the old and the 
insertion of the new SSD, so I don't think that a problem like it was 
described under 
http://superuser.com/questions/942886/fail-device-in-md-raid-when-ata-stops-responding 
took place. Also the VMs went down immediately and not 7 minutes later. 
So - any thoughts on that? Would be greatly appreciated :)

11:45:36 kvm7 kernel: sd 1:0:8:0: device_blocked, handle(0x000b)
11:45:37 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 0
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069640
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069648
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069656
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069664
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069672
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069680
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069688
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069696
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069704
11:45:37 kvm7 kernel: md/raid10:md3: sdk3: rescheduling sector 4072069712
11:45:37 kvm7 kernel: sd 1:0:8:0: [sdk] FAILED Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
11:45:37 kvm7 kernel: sd 1:0:8:0: [sdk] CDB: Read(10) 28 00 20 af f7 08 
00 00 08 00
11:45:37 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 
548402952
11:45:37 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 0
11:45:37 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 
39133192
11:45:37 kvm7 kernel: md: super_written gets error=-5, uptodate=0
11:45:37 kvm7 kernel: md/raid10:md3: Disk failure on sdk3, disabling 
device.#012md/raid10:md3: Operation continuing on 15 devices.
11:45:37 kvm7 kernel: md: md2 still in use.
11:45:37 kvm7 kernel: md/raid10:md2: Disk failure on sdk2, disabling 
device.#012md/raid10:md2: Operation continuing on 15 devices.
11:45:37 kvm7 kernel: blk_update_request: I/O error, dev sdk, sector 
39133264
11:45:37 kvm7 kernel: md: super_written gets error=-5, uptodate=0
11:45:37 kvm7 kernel: sd 1:0:8:0: [sdk] Synchronizing SCSI cache
11:45:37 kvm7 kernel: sd 1:0:8:0: [sdk] Synchronize Cache(10) failed: 
Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
11:45:37 kvm7 kernel: mpt3sas1: removing handle(0x000b), 
sas_addr(0x4433221102000000)
11:45:37 kvm7 kernel: md: unbind<sdk2>
11:45:37 kvm7 kernel: md: export_rdev(sdk2)
11:48:00 kvm7 kernel: INFO: task md3_raid10:1293 blocked for more than 
120 seconds.
11:48:00 kvm7 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
11:48:00 kvm7 kernel: md3_raid10      D ffff883f26e55c00     0 1293      
2 0x00000000
11:48:00 kvm7 kernel: ffff887f24bd7c58 0000000000000046 ffff887f212eb980 
ffff887f24bd7fd8
11:48:00 kvm7 kernel: ffff887f24bd7fd8 ffff887f24bd7fd8 ffff887f212eb980 
ffff887f23514400
11:48:00 kvm7 kernel: ffff887f235144dc 0000000000000001 ffff887f23514500 
ffff8807fa4c4300
11:48:00 kvm7 kernel: Call Trace:
11:48:00 kvm7 kernel: [<ffffffff8163bb39>] schedule+0x29/0x70
11:48:00 kvm7 kernel: [<ffffffffa0104ef7>] freeze_array+0xb7/0x180 [raid10]
11:48:00 kvm7 kernel: [<ffffffff810a6b80>] ? wake_up_atomic_t+0x30/0x30
11:48:00 kvm7 kernel: [<ffffffffa010880d>] handle_read_error+0x2bd/0x360 
[raid10]
11:48:00 kvm7 kernel: [<ffffffff812c7412>] ? generic_make_request+0xe2/0x130
11:48:00 kvm7 kernel: [<ffffffffa0108a1d>] raid10d+0x16d/0x1440 [raid10]
11:48:00 kvm7 kernel: [<ffffffff814bb785>] md_thread+0x155/0x1a0
11:48:00 kvm7 kernel: [<ffffffff810a6b80>] ? wake_up_atomic_t+0x30/0x30
11:48:00 kvm7 kernel: [<ffffffff814bb630>] ? md_safemode_timeout+0x50/0x50
11:48:00 kvm7 kernel: [<ffffffff810a5b8f>] kthread+0xcf/0xe0
11:48:00 kvm7 kernel: [<ffffffff810a5ac0>] ? 
kthread_create_on_node+0x140/0x140
11:48:00 kvm7 kernel: [<ffffffff81646a98>] ret_from_fork+0x58/0x90
11:48:00 kvm7 kernel: [<ffffffff810a5ac0>] ? 
kthread_create_on_node+0x140/0x140
11:48:00 kvm7 kernel: INFO: task qemu-kvm:26929 blocked for more than 
120 seconds.

[serveral messages for stuck qemu-kvm processes]

11:52:42 kvm7 kernel: scsi 1:0:9:0: Direct-Access     ATA KINGSTON 
SKC400S 001A PQ: 0 ANSI: 6
11:52:42 kvm7 kernel: scsi 1:0:9:0: SATA: handle(0x000b), 
sas_addr(0x4433221102000000), phy(2), device_name(0x4d6b497569a68ba2)
11:52:42 kvm7 kernel: scsi 1:0:9:0: SATA: 
enclosure_logical_id(0x500304801c14a001), slot(2)
11:52:42 kvm7 kernel: scsi 1:0:9:0: atapi(n), ncq(y), asyn_notify(n), 
smart(y), fua(y), sw_preserve(y)
11:52:42 kvm7 kernel: scsi 1:0:9:0: qdepth(32), tagged(1), simple(0), 
ordered(0), scsi_level(7), cmd_que(1)
11:52:42 kvm7 kernel: sd 1:0:9:0: Attached scsi generic sg10 type 0
11:52:42 kvm7 kernel: sd 1:0:9:0: [sdq] 2000409264 512-byte logical 
blocks: (1.02 TB/953 GiB)
11:52:42 kvm7 kernel: sd 1:0:9:0: [sdq] Write Protect is off
11:52:42 kvm7 kernel: sd 1:0:9:0: [sdq] Write cache: enabled, read 
cache: enabled, supports DPO and FUA
11:52:42 kvm7 kernel: sdq: unknown partition table
11:52:42 kvm7 kernel: sd 1:0:9:0: [sdq] Attached SCSI disk


Best Regards,
Tim
