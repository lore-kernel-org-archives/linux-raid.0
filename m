From: Neil Brown <neilb@suse.de>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Fri, 9 Jul 2010 08:48:08 +1000
Message-ID: <20100709084808.72fc8fd4@notabene.brown>
References: <20100707204110.GB1207@earth.universe>
	<20100708084450.7abb19d8@notabene.brown>
	<20100707231316.GA6496@earth.universe>
	<20100708112144.1b70d6da@notabene.brown>
	<20100708084837.GA7410@earth.universe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100708084837.GA7410@earth.universe>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Reichel <elektranox@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 8 Jul 2010 10:48:37 +0200
Sebastian Reichel <elektranox@gmail.com> wrote:

> On Thu, Jul 08, 2010 at 11:21:44AM +1000, Neil Brown wrote:
> > On Thu, 8 Jul 2010 01:13:16 +0200
> > Sebastian Reichel <elektranox@gmail.com> wrote:
> > 
> > > On Thu, Jul 08, 2010 at 08:44:50AM +1000, Neil Brown wrote:
> > > > On Wed, 7 Jul 2010 22:41:10 +0200
> > > > Sebastian Reichel <elektranox@gmail.com> wrote:
> > > > 
> > > > > Hi,
> > > > > 
> > > > > I have some problems with my raid. I tried updating from 5 disks raid5 to 8 disks
> > > > > raid6 as described on http://neil.brown.name/blog/20090817000931#2. The command I
> > > > > used was: mdadm --grow /dev/md0 --level=6 --raid-disk=8
> > > > > 
> > > > > While the rebuild was in progress my system hung, so I had to force power down it.
> > > > > After rebooting the system I reassembled the raid. You can see the resulting mess
> > > > > below. How can I recover from this state?
> > > > 
> > > > Please report the output of
> > > > 
> > > >   mdadm -E /dev/sd[efghijkl]1
> > > > 
> > > > then I'll see what can be done.
> > > 
> > > thank you for having a look at it :)
> > 
> > 
> > It appears that the RAID5 -> RAID6 conversion (which is instantaneous, but
> > results in a non-standard RAID6 parity layout) happened, but the 
> > 6disk -> 8disk reshape which would have been combined with producing a
> > more standard RAID6 parity layout did not even begin.
> > I don't know why that would be.  Do you remember seeing the reshape being
> > under-way in /proc/mdstat at all??
> >
> > If you didn't them I am very confused and the following is not at all
> > reliable.  If you didn't and you only assumed a reshape was happening, then
> > read on.
> > 
> > [...]
> > 
> > But if you are sure the reshape actually started the first time, don't do
> > any of this.  Rather try to find some earlier kernel logs that show the
> > reshape starting, and maybe show what caused the crash.
> 
> Yes, I saw the reshape via /proc/mdstat, it already passed 30% iirc.
> Here are the interesting parts of the kernel log:

Ahhh, that helps a lot - thanks.

mdadm successfully converted RAID5 -> RAID6 as I thought, but it hit a bug
(that is aleady fixed in the -stable series - sorry about that).  So the
6disk -> 8disk conversion couldn't be requested.
You stopped and restarted the array which worked and you now have a
degraded RAID6 over 6 devices with a non-standard layout.

As it was degraded and there was a spare it started recovering the missing
devices to a spare.  You thought this was the reshape progressing and in a
sense it was, just not exactly the reshape you were expecting.

You then hit read errors on sdk - at about the 42% mark if my sums are right.

Then it threw a warning about spending too much time in the thread that was
trying to correct the read errors.  Then .... did it hang?

Anyway, this all confirms that I was right about the state of your array.
It is still a degraded 6disk RAID6 with a non-standard layout.

However sdk is clearly questionable.  You might want to exclude it from the
array.  
The rest of my advice about what to do holds.
However you might want to get the latest 2.6.34.y -stable kernel if you can.

BTW, I'm curious about your hang.  You replaced a bunch of errors with
> [...] (more sdk failures)

2 questions:
  1/ was this all "read error corrected" with consecutive addresses?  what
     did the addresses go up to?
  2/ did this continue for the full 4 minutes until the "INFO:" hang message?

Thanks,

NeilBrown


> 
> Jul  6 21:09:14 mars kernel: [ 7716.935683] RAID5 conf printout:
> Jul  6 21:09:14 mars kernel: [ 7716.935688]  --- rd:5 wd:5
> Jul  6 21:09:14 mars kernel: [ 7716.935691]  disk 0, o:1, dev:sdk1
> Jul  6 21:09:14 mars kernel: [ 7716.935693]  disk 1, o:1, dev:sde1
> Jul  6 21:09:14 mars kernel: [ 7716.935695]  disk 2, o:1, dev:sdl1
> Jul  6 21:09:14 mars kernel: [ 7716.935696]  disk 3, o:1, dev:sdj1
> Jul  6 21:09:14 mars kernel: [ 7716.935698]  disk 4, o:1, dev:sdi1
> Jul  6 21:10:04 mars kernel: [ 7766.940183] raid5: device sdk1 operational as raid disk 0
> Jul  6 21:10:04 mars kernel: [ 7766.940186] raid5: device sdi1 operational as raid disk 4
> Jul  6 21:10:04 mars kernel: [ 7766.940189] raid5: device sdj1 operational as raid disk 3
> Jul  6 21:10:04 mars kernel: [ 7766.940191] raid5: device sdl1 operational as raid disk 2
> Jul  6 21:10:04 mars kernel: [ 7766.940193] raid5: device sde1 operational as raid disk 1
> Jul  6 21:10:04 mars kernel: [ 7766.940840] raid5: allocated 6386kB for md0
> Jul  6 21:10:04 mars kernel: [ 7766.952476] 0: w=1 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
> Jul  6 21:10:04 mars kernel: [ 7766.952480] 4: w=2 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
> Jul  6 21:10:04 mars kernel: [ 7766.952482] 3: w=3 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
> Jul  6 21:10:04 mars kernel: [ 7766.952485] 2: w=4 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
> Jul  6 21:10:04 mars kernel: [ 7766.952487] 1: w=5 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
> Jul  6 21:10:04 mars kernel: [ 7766.952490] raid5: raid level 6 set md0 active with 5 out of 6 devices, algorithm 18
> Jul  6 21:10:04 mars kernel: [ 7766.952516] RAID5 conf printout:
> Jul  6 21:10:04 mars kernel: [ 7766.952517]  --- rd:6 wd:5
> Jul  6 21:10:04 mars kernel: [ 7766.952520]  disk 0, o:1, dev:sdk1
> Jul  6 21:10:04 mars kernel: [ 7766.952522]  disk 1, o:1, dev:sde1
> Jul  6 21:10:04 mars kernel: [ 7766.952523]  disk 2, o:1, dev:sdl1
> Jul  6 21:10:04 mars kernel: [ 7766.952525]  disk 3, o:1, dev:sdj1
> Jul  6 21:10:04 mars kernel: [ 7766.952527]  disk 4, o:1, dev:sdi1
> Jul  6 21:10:04 mars kernel: [ 7766.952536] ------------[ cut here ]------------
> Jul  6 21:10:04 mars kernel: [ 7766.952542] WARNING: at /build/buildd-linux-2.6_2.6.34-1~experimental.2-amd64-zn0ozk/linux-2.6-2.6.34/debian/build/source_amd64_none/fs/sysfs/dir.c:451 sysfs_add_one+0xcc/0xe3()
> Jul  6 21:10:04 mars kernel: [ 7766.952545] Hardware name: System Product Name
> Jul  6 21:10:04 mars kernel: [ 7766.952547] sysfs: cannot create duplicate filename '/devices/virtual/block/md0/md/stripe_cache_size'
> Jul  6 21:10:04 mars kernel: [ 7766.952549] Modules linked in: ip6t_LOG xt_hl nf_conntrack_ipv6 ipt_REJECT ipt_LOG xt_limit xt_tcpudp ipt_addrtype ipt_MASQUERADE iptable_nat xt_state ip6table_filter ip6_tables nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables nfsd nfs lockd fscache nfs_acl auth_rpcgss sunrpc pppoe pppox ppp_generic xfs exportfs rr272x_1x(P) hwmon_vid loop sha256_generic aes_x86_64 aes_generic cbc dm_crypt dm_mod arc4 ecb dvb_pll ath5k hfcpci mac80211 stv0299 b2c2_flexcop_pci mISDN_core ath b2c2_flexcop hisax dvb_core snd_pcm cx24123 snd_timer crc_ccitt cfg80211 cx24113 isdn snd rfkill s5h1420 soundcore i2c_nforce2 evdev pcspkr led_class snd_page_alloc edac_core edac_mce_amd i2c_c
 ore k8temp slhc tpm_tis tpm tpm_bios processor button asus_atk0110 ext3 jbd mbcache raid456 md_mod async_raid6_recov async_pq raid6_pq async_xor xor async_memcpy async_tx ohci_hcd sd_mod crc
 _t10dif ata_generic fan firewire_ohci
> Jul  6 21:10:04 mars kernel: ehci_hcd pata_amd firewire_core crc_itu_t thermal thermal_sys sata_nv usbcore nls_base libata forcedeth scsi_mod [last unloaded: scsi_wait_scan]
> Jul  6 21:10:04 mars kernel: [ 7766.952622] Pid: 6844, comm: mdadm Tainted: P        W  2.6.34-1-amd64 #1
> Jul  6 21:10:04 mars kernel: [ 7766.952624] Call Trace:
> Jul  6 21:10:04 mars kernel: [ 7766.952630]  [<ffffffff81045655>] ? warn_slowpath_common+0x76/0x8c
> Jul  6 21:10:04 mars kernel: [ 7766.952635]  [<ffffffff810456bd>] ? warn_slowpath_fmt+0x40/0x45
> Jul  6 21:10:04 mars kernel: [ 7766.952638]  [<ffffffff81138209>] ? sysfs_add_one+0xcc/0xe3
> Jul  6 21:10:04 mars kernel: [ 7766.952642]  [<ffffffff81137416>] ? sysfs_add_file_mode+0x4b/0x7d
> Jul  6 21:10:04 mars kernel: [ 7766.952646]  [<ffffffff8113933c>] ? internal_create_group+0xdd/0x16b
> Jul  6 21:10:04 mars kernel: [ 7766.952652]  [<ffffffffa01a0f67>] ? run+0x4fa/0x685 [raid456]
> Jul  6 21:10:04 mars kernel: [ 7766.952660]  [<ffffffffa0181b20>] ? level_store+0x3b7/0x42e [md_mod]
> Jul  6 21:10:04 mars kernel: [ 7766.952667]  [<ffffffffa017eb1f>] ? md_attr_store+0x77/0x96 [md_mod]
> Jul  6 21:10:04 mars kernel: [ 7766.952670]  [<ffffffff81136ede>] ? sysfs_write_file+0xe3/0x11f
> Jul  6 21:10:04 mars kernel: [ 7766.952674]  [<ffffffff810e7bc6>] ? vfs_write+0xa4/0x101
> Jul  6 21:10:04 mars kernel: [ 7766.952677]  [<ffffffff810e7cd6>] ? sys_write+0x45/0x6b
> Jul  6 21:10:04 mars kernel: [ 7766.952680]  [<ffffffff810089c2>] ? system_call_fastpath+0x16/0x1b
> Jul  6 21:10:04 mars kernel: [ 7766.952682] ---[ end trace 2d8a2ef8dd7ca7b7 ]---
> Jul  6 21:10:04 mars kernel: [ 7766.952687] raid5: failed to create sysfs attributes for md0
> Jul  6 21:21:10 mars kernel: [ 8432.471242] md: md0 stopped.
> [...]
> Jul  6 21:25:23 mars kernel: [ 8685.659605] raid5: raid level 6 set md0 active with 5 out of 6 devices, algorithm 18
> Jul  6 21:25:23 mars kernel: [ 8685.659631] RAID5 conf printout:
> Jul  6 21:25:23 mars kernel: [ 8685.659632]  --- rd:6 wd:5
> Jul  6 21:25:23 mars kernel: [ 8685.659634]  disk 0, o:1, dev:sdk1
> Jul  6 21:25:23 mars kernel: [ 8685.659636]  disk 1, o:1, dev:sde1
> Jul  6 21:25:23 mars kernel: [ 8685.659638]  disk 2, o:1, dev:sdl1
> Jul  6 21:25:23 mars kernel: [ 8685.659640]  disk 3, o:1, dev:sdj1
> Jul  6 21:25:23 mars kernel: [ 8685.659641]  disk 4, o:1, dev:sdi1
> Jul  6 21:25:23 mars kernel: [ 8685.659677] md0: detected capacity change from 0 to 6001196793856
> Jul  6 21:25:23 mars kernel: [ 8685.659813]  md0: unknown partition table
> [...]
> Jul  6 21:28:16 mars kernel: [ 8858.893402] md: recovery of RAID array md0
> Jul  6 21:28:16 mars kernel: [ 8858.893405] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jul  6 21:28:16 mars kernel: [ 8858.893407] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Jul  6 21:28:16 mars kernel: [ 8858.893422] md: using 128k window, over a total of 1465135936 blocks.
> [...]
> Jul  6 21:31:18 mars kernel: [ 9040.089434] rr272x_1x:Device error information 0x1000000
> Jul  6 21:31:18 mars kernel: [ 9040.089440] rr272x_1x:Task file error, StatusReg=0x41, ErrReg=0x4, LBA[0-3]=0x17fbec6,LBA[4-7]=0x0.
> [...] (more of these messages)
> Jul  6 23:54:20 mars kernel: [17622.164846] sd 8:0:6:0: [sdk] Unhandled error code
> Jul  6 23:54:20 mars kernel: [17622.164848] sd 8:0:6:0: [sdk] Result: hostbyte=DID_ABORT driverbyte=DRIVER_INVALID
> Jul  6 23:54:20 mars kernel: [17622.164851] sd 8:0:6:0: [sdk] CDB: Read(10): 28 00 49 ff 72 3f 00 00 38 00
> Jul  6 23:54:20 mars kernel: [17622.164858] end_request: I/O error, dev sdk, sector 1241477695
> Jul  6 23:54:20 mars kernel: [17622.181377] raid5:md0: read error corrected (8 sectors at 1241477632 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181503] raid5:md0: read error corrected (8 sectors at 1241477640 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181507] raid5:md0: read error corrected (8 sectors at 1241477648 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181510] raid5:md0: read error corrected (8 sectors at 1241477656 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181512] raid5:md0: read error corrected (8 sectors at 1241477664 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181515] raid5:md0: read error corrected (8 sectors at 1241477672 on sdk1)
> Jul  6 23:54:20 mars kernel: [17622.181518] raid5:md0: read error corrected (8 sectors at 1241477680 on sdk1)
> [...] (more sdk failures)
> Jul  6 23:58:38 mars kernel: [17880.544030] INFO: task md0_resync:13565 blocked for more than 120 seconds.
> Jul  6 23:58:38 mars kernel: [17880.544109] md0_resync    D ffff88007cdf9500     0 13565      2 0x00000000
> Jul  6 23:58:38 mars kernel: [17880.544114]  ffff88007cdf9500 0000000000000046 0000000000000086 ffff88007400a800
> Jul  6 23:58:38 mars kernel: [17880.544117]  ffff88007ce25400 0000000000015200 0000000000015200 0000000000015200
> Jul  6 23:58:38 mars kernel: [17880.544120]  ffff88006baf5fd8 0000000000015200 ffff88007cdf9500 ffff88006baf5fd8
> Jul  6 23:58:38 mars kernel: [17880.544124] Call Trace:
> Jul  6 23:58:38 mars kernel: [17880.544145]  [<ffffffffa019bdef>] ? unplug_slaves+0x70/0xa6 [raid456]
> Jul  6 23:58:38 mars kernel: [17880.544150]  [<ffffffffa019c17e>] ? get_active_stripe+0x26f/0x54b [raid456]
> Jul  6 23:58:38 mars kernel: [17880.544154]  [<ffffffff81040b38>] ? default_wake_function+0x0/0xf
> Jul  6 23:58:38 mars kernel: [17880.544159]  [<ffffffffa019ef3b>] ? sync_request+0x245/0x2d1 [raid456]
> Jul  6 23:58:38 mars kernel: [17880.544166]  [<ffffffffa01809d4>] ? is_mddev_idle+0xa2/0xf5 [md_mod]
> Jul  6 23:58:38 mars kernel: [17880.544172]  [<ffffffffa018113a>] ? md_do_sync+0x713/0xb0f [md_mod]
> Jul  6 23:58:38 mars kernel: [17880.544177]  [<ffffffff8105d495>] ? autoremove_wake_function+0x0/0x2a
> Jul  6 23:58:38 mars kernel: [17880.544182]  [<ffffffffa0181c89>] ? md_thread+0xf2/0x110 [md_mod]
> Jul  6 23:58:38 mars kernel: [17880.544188]  [<ffffffffa0181b97>] ? md_thread+0x0/0x110 [md_mod]
> Jul  6 23:58:38 mars kernel: [17880.544190]  [<ffffffff8105d061>] ? kthread+0x75/0x7d
> Jul  6 23:58:38 mars kernel: [17880.544194]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
> Jul  6 23:58:38 mars kernel: [17880.544197]  [<ffffffff8105cfec>] ? kthread+0x0/0x7d
> Jul  6 23:58:38 mars kernel: [17880.544199]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10

