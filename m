From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Tue, 20 Jun 2006 06:35:29 -0400
Message-ID: <4497CF71.5050906@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net>	<17556.31295.280083.533342@cse.unsw.edu.au>	<44947BCA.9040305@nigelterry.net>	<44947C98.6060809@nigelterry.net>	<17556.32630.611922.294047@cse.unsw.edu.au>	<44948002.3050706@nigelterry.net>	<44954DB7.2000305@nigelterry.net>	<17558.1521.522659.91428@cse.unsw.edu.au>	<44971A51.6050008@nigelterry.net>	<17559.10564.840472.525999@cse.unsw.edu.au>	<44972AF1.8040500@nigelterry.net> <17559.13371.751956.423312@cse.unsw.edu.au> <449734AE.10907@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449734AE.10907@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nigel J. Terry wrote:

Well good news and bad news I'm afraid...

Well I would like to be able to tell you that the time calculation now 
works, but I can't. Here's why: Why I rebooted with the newly built 
kernel, it decided to hit the magic 21 reboots and hence decided to 
check the array for clean. The normally takes about 5-10 mins, but this 
time took several hours, so I went to bed! I suspect that it was doing 
the full reshape or something similar at boot time.

Now I am not sure that this makes good sense in a normal environment. 
This could keep a server down for hours or days. I might suggest that if 
such work was required, the clean check is postponed till next boot and 
the reshape allowed to continue in the background.

Anyway the good news is that this morning, all is well, the array is 
clean and grown as can be seen below. However, if you look further below 
you will see the section from dmesg which still shows RIP errors, so I 
guess there is still something wrong, even though it looks like it is 
working. Let me know if i can provide any more information.

Once again, many thanks. All I need to do now is grow the ext3 filesystem...

Nigel

[root@homepc ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Apr 18 17:44:34 2006
     Raid Level : raid5
     Array Size : 735334656 (701.27 GiB 752.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Jun 20 06:27:49 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 50e3173e:b5d2bdb6:7db3576b:644409bb
         Events : 0.3366644

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       3       65        2      active sync   /dev/hdb1
       3      22        1        3      active sync   /dev/hdc1
[root@homepc ~]# cat /proc/mdstat
Personalities : [raid5] [raid4]
md0 : active raid5 sdb1[1] sda1[0] hdc1[3] hdb1[2]
      735334656 blocks level 5, 128k chunk, algorithm 2 [4/4] [UUUU]

unused devices: <none>
[root@homepc ~]#

But from dmesg:

md: Autodetecting RAID arrays.
md: autorun ...
md: considering sdb1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md:  adding hdc1 ...
md:  adding hdb1 ...
md: created md0
md: bind<hdb1>
md: bind<hdc1>
md: bind<sda1>
md: bind<sdb1>
md: running: <sdb1><sda1><hdc1><hdb1>
raid5: automatically using best checksumming function: generic_sse
   generic_sse:  6795.000 MB/sec
raid5: using function: generic_sse (6795.000 MB/sec)
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
raid5: reshape will continue
raid5: device sdb1 operational as raid disk 1
raid5: device sda1 operational as raid disk 0
raid5: device hdb1 operational as raid disk 2
raid5: allocated 4268kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:sda1
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:hdb1
...ok start reshape thread
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for reconstruction.
md: using 128k window, over a total of 245111552 blocks.
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
<0000000000000000>{stext+2145382632}
PGD 7c3f9067 PUD 7cb9e067 PMD 0
Oops: 0010 [1] SMP
CPU 0
Modules linked in: raid5 xor usb_storage video button battery ac lp 
parport_pc parport floppy nvram snd_intel8x0 snd_ac97_codec snd_ac97_bus 
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device 
snd_pcm_oss snd_mixer_oss ehci_hcd ohci1394 ieee1394 sg snd_pcm uhci_hcd 
i2c_nforce2 i2c_core forcedeth ohci_hcd snd_timer snd soundcore 
snd_page_alloc dm_snapshot dm_zero dm_mirror dm_mod ext3 jbd sata_nv 
libata sd_mod scsi_mod
Pid: 1432, comm: md0_reshape Not tainted 2.6.17-rc6 #1
RIP: 0010:[<0000000000000000>] <0000000000000000>{stext+2145382632}
RSP: 0000:ffff81007aa43d60  EFLAGS: 00010246
RAX: ffff81007cf72f20 RBX: ffff81007c682000 RCX: 0000000000000006
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff81007cf72f20
RBP: 0000000002090900 R08: 0000000000000000 R09: ffff810037f497b0
R10: 0000000b44ffd564 R11: ffffffff8022c92a R12: 0000000000000000
R13: 0000000000000100 R14: 0000000000000000 R15: 0000000000000000
FS:  000000000066d870(0000) GS:ffffffff80611000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007bebc000 CR4: 00000000000006e0
Process md0_reshape (pid: 1432, threadinfo ffff81007aa42000, task 
ffff810037f497b0)
Stack: ffffffff803dce42 0000000000000000 000000001d383600 0000000000000000
       0000000000000000 0000000000000000 0000000000000000 0000000000000000
       0000000000000000 0000000000000000
Call Trace: <ffffffff803dce42>{md_do_sync+1307} 
<ffffffff802640c0>{thread_return+0}
       <ffffffff8026411e>{thread_return+94} 
<ffffffff8029925d>{keventd_create_kthread+0}
       <ffffffff803dd3d9>{md_thread+248} 
<ffffffff8029925d>{keventd_create_kthread+0}
       <ffffffff803dd2e1>{md_thread+0} <ffffffff80232cb1>{kthread+254}
       <ffffffff8026051e>{child_rip+8} 
<ffffffff8029925d>{keventd_create_kthread+0}
       <ffffffff802640c0>{thread_return+0} <ffffffff80232bb3>{kthread+0}
       <ffffffff80260516>{child_rip+0}

Code:  Bad RIP value.
RIP <0000000000000000>{stext+2145382632} RSP <ffff81007aa43d60>
CR2: 0000000000000000
 <6>md: ... autorun DONE.
