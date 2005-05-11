From: John McMonagle <johnm@advocap.org>
Subject: Re: grow problem
Date: Wed, 11 May 2005 08:55:20 -0500
Message-ID: <42820EC8.1020300@advocap.org>
References: <42812E77.9060503@advocap.org> <17025.18070.800000.318669@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17025.18070.800000.318669@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday May 10, johnm@advocap.org wrote:
>  
>
>>Having a problem changing my number of mirrors on a raid1 from 3 to 2.
>>
>>Did it about a week ago on another system so I'm a bit perplexed.
>>
>>mdadm --grow /dev/md0 --raid-disks 2
>>mdadm: Cannot set device size/shape for /dev/md0: Device or resource busy
>>
>> cat /proc/mdstat
>>Personalities : [raid1]
>>md0 : active raid1 sda1[0] hda1[2]
>>      976640 blocks [3/2] [U_U]
>>    
>>
>
>md/raid1 currently requires and devices that you plan to remove with
>--grow, to already be missing.
>
>So you would need to fail and re-add hda1, which would mean a full
>rebuild :-(
>
>If you can afford to:
>   - wait a few days
>   - recompile your kernel
>   - be a guinea pig
>
>I can get raid1 to try to move devices into earlier holes before
>reducing the size.  Let me know, and I'll start working on a patch.
>
>NeilBrown
>  
>
Neil

That did it.  Thanks.

I don't have time at the moment to try patches :(

Probably unrelated but I'll pass it on just in case it's useful.

Added to md0 with no problem.
When added to md1 got a kernel panic.
Happened to have serial console logging to this is what is says:
.............................................
^MRAID1 conf printout:
^M --- wd:2 rd:2
^M disk 0, wo:0, o:1, dev:sda1
^M disk 1, wo:0, o:1, dev:hda1
^Mmd: bind<hda2>
^MRAID1 conf printout:
^M --- wd:1 rd:2
^M disk 0, wo:0, o:1, dev:sda2
^M disk 1, wo:1, o:1, dev:hda2
^M...........................................................................................................
.............................................................................................................
.............................................................................................................
.............................................................................................................
..............................................................................<6>md: 
syncing RAID array md1
^Mmd: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
^Mmd: using maximum available idle IO bandwith (but not more than 200000 
KB/sec) for reconstruction.
^Mmd: using 128k window, over a total of 77173888 blocks.
^MUnable to handle kernel paging request at virtual address 0001003b
^M printing eip:
^Mf883a262
^M*pde = 00000000
^MOops: 0000 [#1]
^MPREEMPT SMP
^MModules linked in: nfsd exportfs lockd sunrpc parport_pc lp parport 
autofs4 capability commoncap ipv6 flopp
y tsdev mousedev pcspkr evdev psmouse i2c_i801 hw_random ehci_hcd 
uhci_hcd usbcore shpchp pci_hotplug intel_a
gp intel_mch_agp agpgart e100 mii e1000 quota_v2 reiserfs w83627hf 
eeprom i2c_sensor i2c_isa i2c_viapro i2c_c
ore ide_cd softdog genrtc ext3 jbd mbcache ide_disk ide_generic 
via82cxxx trm290 triflex slc90e66 sis5513 sii
mage serverworks sc1200 rz1000 piix pdc202xx_old opti621 ns87415 hpt366 
hpt34x generic cy82c693 cs5530 cs5520
 cmd64x atiixp amd74xx alim15x3 aec62xx pdc202xx_new sr_mod cdrom 
ide_scsi ide_core sd_mod ata_piix libata sg
 scsi_mod unix raid1 dm_mirror dm_snapshot dm_mod md
^MCPU:    1
^MEIP:    0060:[<f883a262>]    Not tainted VLI
^MEFLAGS: 00010206   (2.6.11-p4smp)
^MEIP is at sync_request+0x552/0x590 [raid1]
^Meax: 00000018   ebx: f5f81c00   ecx: 00000002   edx: 0000ffff
^Mesi: 00000000   edi: 00000002   ebp: 00000000   esp: f592de1c
^Mds: 007b   es: 007b   ss: 0068
^MProcess md1_resync (pid: 6843, threadinfo=f592c000 task=f62ef020)
^MStack: c1aec780 00000080 00000000 00008a44 00008a44 ffffffc5 c02abaaf 
c011db29
^M       00000000 00008a44 c03a46bb 00000286 00000000 00000000 c011d9a0 
09332900
^M       00000000 f8831f00 c1aec780 00000000 00000000 c1bee800 00000000 
00000000
^MCall Trace:
^M [<c02abaaf>] _spin_unlock_irqrestore+0xf/0x30
^M [<c011db29>] release_console_sem+0xb9/0xc0
^M [<c011d9a0>] vprintk+0x120/0x170
^M [<f882fc97>] md_do_sync+0x497/0x9f0 [md]
^M [<c0116a38>] recalc_task_prio+0x88/0x150
^M [<c0118386>] load_balance_newidle+0x36/0xa0
^M [<f882e844>] md_thread+0x144/0x190 [md]
^M [<c0132c60>] autoremove_wake_function+0x0/0x60
^M [<c0103172>] ret_from_fork+0x6/0x14
^M [<c0132c60>] autoremove_wake_function+0x0/0x60
^M [<f882e700>] md_thread+0x0/0x190 [md]
^M [<c0101375>] kernel_thread_helper+0x5/0x10
^MCode: 0c e9 c4 fc ff ff 8d 76 00 c7 43 34 90 95 83 f8 eb b7 8d b4 26 
00 00 00 00 8b 54 24 48 8b 7a 08 8d 04
 7f 8d 04 83 e9 96 fb ff ff <8b> 6a 3c 85 ed 0f 84 7a fb ff ff e9 9b fb 
ff ff c7 04 24 e8 03


This is  debian unstable 2.6.11 kernel source with  ata patched for  
smart access on sata.

After rebooting it's resyncing with out problem so far.  It's at 75% now.

John

