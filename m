From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Re: Raid5 reshape
Date: Sun, 18 Jun 2006 08:57:27 -0400
Message-ID: <44954DB7.2000305@nigelterry.net>
References: <449250ED.7090302@irule.net>	<17554.21119.487820.638171@cse.unsw.edu.au>	<4492D5B1.60004@nigelterry.net>	<4492D8D9.7010101@irule.net>	<17555.12441.42212.93049@cse.unsw.edu.au>	<4493330E.30501@nigelterry.net>	<17555.13409.834439.80361@cse.unsw.edu.au>	<44945643.3070300@nigelterry.net>	<17556.31295.280083.533342@cse.unsw.edu.au>	<44947BCA.9040305@nigelterry.net>	<44947C98.6060809@nigelterry.net> <17556.32630.611922.294047@cse.unsw.edu.au> <44948002.3050706@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44948002.3050706@nigelterry.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nigel J. Terry wrote:
> Neil Brown wrote:
>> OK, thanks for the extra details.  I'll have a look and see what I can
>> find, but it'll probably be a couple of days before I have anything
>> useful for you.
>>
>> NeilBrown
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>   
>
This from dmesg might help diagnose the problem:

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
