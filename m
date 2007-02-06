From: "Yu-Chen Wu" <g944370@oz.nthu.edu.tw>
Subject: Could "bio_vec" be referenced any time?
Date: Tue, 6 Feb 2007 23:17:31 +0800
Message-ID: <005a01c74a01$ec1832a0$0100a8c0@sslabmayasky>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
	I write a module that creates a kernel thread to show the BIOs from
MD modules.
	The kernel thread will call show_bio() when md passing a BIO to my
module,else sleep.
	Sometimes, show_bio() continues working successfully ,but it
somtimes makes "general protection fault".
	The show_bio() always works when I comment the
"bio_for_each_segment" loop. 
	Is the zone I comment the cause of the fault? 
	As above, I consider it's the main problem.Also, I strongly want to
know your opinions.Thank you for help.

	THX

void show_bio(struct bio *bio)
{
        int segno;
        struct bio_vec *bvec;
        struct bio *pbio;
        //pbio=bio_clone(bio,GFP_KERNEL);
        printk(KERN_INFO "#### bio info #### add segno:%x\n",&segno);
        printk(KERN_INFO "start:%Lu, len :%Lu, bi_vcnt:%d,
bi_phys_segments:%d bi_hw_segments:%d\n",
 
bio->bi_sector,bio->bi_size,bio->bi_vcnt,bio->bi_phys_segments,bio->bi_hw_se
gments);
        /*
        bio_for_each_segment(bvec,bio,segno)
        {

                if(page_has_buffers(bvec->bv_page))
                        printk("page_has_buffer!\n");
                printk(KERN_INFO "page:%x bv_len:%d bv_offset:%d \n",
                bvec->bv_page,
                bvec->bv_len,
                bvec->bv_offset);
        }
        */


}

=============
Error message
=============


Feb  6 22:00:28 RAID-SUSE kernel: general protection fault: 0000 [1] SMP
Feb  6 22:00:28 RAID-SUSE kernel: last sysfs file: /class/net/eth1/carrier
Feb  6 22:00:28 RAID-SUSE kernel: CPU 0
Feb  6 22:00:28 RAID-SUSE kernel: Modules linked in: ext2 raid0 readhelper
af_packet ipv6 snd_pcm_oss snd_mixer_oss snd_seq sn
d_seq_device cpufreq_conservative cpufreq_ondemand cpufreq_userspace
cpufreq_powersave speedstep_centrino freq_table button ba
ttery ac kqemu apparmor aamatch_pcre nls_utf8 ntfs loop dm_mod sr_mod cdrom
generic ide_core snd_hda_intel snd_hda_codec snd_p
cm snd_timer uhci_hcd snd ehci_hcd i2c_i801 i2c_core ohci1394 intel_agp
usbcore sk98lin soundcore ieee1394 pata_jmicron snd_pa
ge_alloc floppy sky2 ext3 mbcache jbd edd fan sg ahci libata thermal
processor sd_mod scsi_mod
Feb  6 22:00:28 RAID-SUSE kernel: Pid: 4176, comm: read_helper_0 Tainted: PF
U 2.6.18.2-34-yuchen-SUSE #5
Feb  6 22:00:28 RAID-SUSE kernel: RIP: 0010:[<ffffffff8845921d>]
[<ffffffff8845921d>] :readhelper:show_bio+0x57/0x9c
Feb  6 22:00:28 RAID-SUSE kernel: RSP: 0018:ffff81007e0efdf0  EFLAGS:
00010293
Feb  6 22:00:28 RAID-SUSE kernel: RAX: 6b6b6b6b6b6b6b6b RBX:
ffff810037f52668 RCX: 0000000000040000
Feb  6 22:00:28 RAID-SUSE kernel: RDX: 00000000001debb8 RSI:
0000000000040000 RDI: ffffffff804ace40
Feb  6 22:00:28 RAID-SUSE kernel: RBP: ffff81007e0efe20 R08:
00000000ffffffff R09: 0000000000000020
Feb  6 22:00:28 RAID-SUSE kernel: R10: 0000000000000000 R11:
0000000000000001 R12: 0000000000000000
Feb  6 22:00:28 RAID-SUSE kernel: R13: 0000000000000068 R14:
ffff81005f01fcd8 R15: ffffffff802937e5
Feb  6 22:00:28 RAID-SUSE kernel: FS:  0000000000000000(0000)
GS:ffffffff805ba000(0000) knlGS:0000000000000000
Feb  6 22:00:28 RAID-SUSE kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
000000008005003b
Feb  6 22:00:28 RAID-SUSE kernel: CR2: 00002b4e8a3188b0 CR3:
0000000000201000 CR4: 00000000000006e0
Feb  6 22:00:28 RAID-SUSE kernel: Process read_helper_0 (pid: 4176,
threadinfo ffff81007e0ee000, task ffff81007b5787f0)
Feb  6 22:00:28 RAID-SUSE kernel: Stack:  ffffffff8025d8db ffff81007e0efea0
00000000ffffffff ffff81007b8c8618
Feb  6 22:00:28 RAID-SUSE kernel:  0000000000000282 ffffffff884592dc
000000000000c000 0000000000000000
Feb  6 22:00:28 RAID-SUSE kernel:  ffff81007c22dcd0 1000000000000001
0000000000000000 0002000200000002
Feb  6 22:00:28 RAID-SUSE kernel: Call Trace:
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff8025d8db>]
thread_return+0x0/0xef
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff884592dc>]
:readhelper:a+0x7a/0x83
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff802d3877>]
dio_bio_end_io+0x0/0x7a
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff8024d5dd>]
bio_fs_destructor+0x0/0xc
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff8024c015>]
finish_wait+0x32/0x5d
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff884598ca>]
:readhelper:thread_func_th0+0xf7/0x115
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff802939a8>]
autoremove_wake_function+0x0/0x2e
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff884597d3>]
:readhelper:thread_func_th0+0x0/0x115
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff802314d6>] kthread+0xec/0x120
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff80259e98>] child_rip+0xa/0x12
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff802937e5>]
keventd_create_kthread+0x0/0x61
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff802313ea>] kthread+0x0/0x120
Feb  6 22:00:28 RAID-SUSE kernel:  [<ffffffff80259e8e>] child_rip+0x0/0x12
Feb  6 22:00:28 RAID-SUSE kernel:
Feb  6 22:00:28 RAID-SUSE kernel:
Feb  6 22:00:28 RAID-SUSE kernel: Code: 8b 00 f6 c4 08 74 0e 48 c7 c7 14 9c
45 88 31 c0 e8 b5 bf e2
Feb  6 22:00:28 RAID-SUSE kernel: RIP  [<ffffffff8845921d>]
:readhelper:show_bio+0x57/0x9c
Feb  6 22:00:28 RAID-SUSE kernel:  RSP <ffff81007e0efdf0>


