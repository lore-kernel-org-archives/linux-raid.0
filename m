From: Yi Zhang <yizhan@redhat.com>
Subject: test file disappeared after -f, -r, --add-journal for write-journal
 device
Date: Wed, 27 Jul 2016 08:07:19 -0400 (EDT)
Message-ID: <1403590832.9411207.1469621239264.JavaMail.zimbra@redhat.com>
References: <678915290.9410266.1469620858173.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <678915290.9410266.1469620858173.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.com, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

Hello maintainer

Here is another strange phenomenon I found after do -f, -r, --add-journal for write-journal device.

Kernel version: 4.7.0-rc7 
Steps I used:
mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 7 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 /dev/loop5 /dev/loop6 /dev/loop7 --write-journal /dev/loop0 --bitmap=internal --bitmap-chunk=64M --chunk 512
mdadm --wait /dev/md0
mkfs.ext4 /dev/md0
mount -t ext4 /dev/md0 /mnt/fortest
cp bigfile /mnt/fortest &
wait
md5sum /mnt/fortest/bigfile > md5sum3
mdadm /dev/md0 -f /dev/loop0
mdadm /dev/md0 -r /dev/loop0
umount /dev/md0 -l
mdadm -o /dev/md0
mdadm /dev/md0 --add-journal /dev/loop0
mdadm --wait /dev/md0
mdadm -D /dev/md0
mount /dev/md0 /mnt/fortest
md5sum /mnt/fortest/bigfile > md5sum2   #<----this test file disappeared

kernel log:
<6>[ 3452.198142] md: bind<loop1>
<6>[ 3452.198176] md: bind<loop2>
<6>[ 3452.198202] md: bind<loop3>
<6>[ 3452.198224] md: bind<loop4>
<6>[ 3452.198244] md: bind<loop5>
<6>[ 3452.198265] md: bind<loop6>
<6>[ 3452.198289] md: bind<loop0>
<6>[ 3452.198317] md: bind<loop7>
<6>[ 3452.203183] md/raid:md0: device loop6 operational as raid disk 5
<6>[ 3452.203186] md/raid:md0: device loop5 operational as raid disk 4
<6>[ 3452.203187] md/raid:md0: device loop4 operational as raid disk 3
<6>[ 3452.203188] md/raid:md0: device loop3 operational as raid disk 2
<6>[ 3452.203189] md/raid:md0: device loop2 operational as raid disk 1
<6>[ 3452.203190] md/raid:md0: device loop1 operational as raid disk 0
<6>[ 3452.203684] md/raid:md0: allocated 7548kB
<1>[ 3452.203796] md/raid:md0: raid level 4 active with 6 out of 7 devices, algorithm 0
<7>[ 3452.203800] RAID conf printout:
<7>[ 3452.203801]  --- level:4 rd:7 wd:6
<7>[ 3452.203802]  disk 0, o:1, dev:loop1
<7>[ 3452.203803]  disk 1, o:1, dev:loop2
<7>[ 3452.203804]  disk 2, o:1, dev:loop3
<7>[ 3452.203805]  disk 3, o:1, dev:loop4
<7>[ 3452.203806]  disk 4, o:1, dev:loop5
<7>[ 3452.203807]  disk 5, o:1, dev:loop6
<6>[ 3452.203815] md/raid456: discard support disabled due to uncertainty.
<6>[ 3452.203816] Set raid456.devices_handle_discard_safely=Y to override.
<6>[ 3452.203819] md/raid:md0: using device loop0 as journal
<6>[ 3452.204161] created bitmap (1 pages) for device md0
<6>[ 3452.204202] md0: bitmap initialized from disk: read 1 pages, set 8 of 8 bits
<6>[ 3452.271446] md0: detected capacity change from 0 to 3214934016
<7>[ 3452.271474] RAID conf printout:
<7>[ 3452.271477]  --- level:4 rd:7 wd:6
<7>[ 3452.271478]  disk 0, o:1, dev:loop1
<7>[ 3452.271479]  disk 1, o:1, dev:loop2
<7>[ 3452.271480]  disk 2, o:1, dev:loop3
<7>[ 3452.271481]  disk 3, o:1, dev:loop4
<7>[ 3452.271482]  disk 4, o:1, dev:loop5
<7>[ 3452.271483]  disk 5, o:1, dev:loop6
<7>[ 3452.271484]  disk 6, o:1, dev:loop7
<6>[ 3452.271613] md: recovery of RAID array md0
<6>[ 3452.271616] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
<6>[ 3452.271617] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
<6>[ 3452.271625] md: using 128k window, over a total of 523264k.
<4>[ 3452.484361] md: couldn't update array info. -22
<4>[ 3452.536719] md: couldn't update array info. -22
<4>[ 3452.550794] md: couldn't update array info. -22
<4>[ 3453.276007] md: couldn't update array info. -22
<4>[ 3454.076132] md: couldn't update array info. -22
<4>[ 3454.859359] md: couldn't update array info. -22
<4>[ 3455.638082] md: couldn't update array info. -22
<6>[ 3465.044292] md: md0: recovery done.
<7>[ 3465.996564] RAID conf printout:
<7>[ 3465.996567]  --- level:4 rd:7 wd:7
<7>[ 3465.996568]  disk 0, o:1, dev:loop1
<7>[ 3465.996569]  disk 1, o:1, dev:loop2
<7>[ 3465.996570]  disk 2, o:1, dev:loop3
<7>[ 3465.996571]  disk 3, o:1, dev:loop4
<7>[ 3465.996572]  disk 4, o:1, dev:loop5
<7>[ 3465.996572]  disk 5, o:1, dev:loop6
<7>[ 3465.996573]  disk 6, o:1, dev:loop7
<6>[ 3470.361924] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)
<1>[ 3471.084961] md/raid:md0: Disk failure on loop0, disabling device.
<1>[ 3471.084961] md/raid:md0: Operation continuing on 7 devices.
<7>[ 3471.253666] RAID conf printout:
<7>[ 3471.253669]  --- level:4 rd:7 wd:7
<7>[ 3471.253671]  disk 0, o:1, dev:loop1
<7>[ 3471.253672]  disk 1, o:1, dev:loop2
<7>[ 3471.253672]  disk 2, o:1, dev:loop3
<7>[ 3471.253686]  disk 3, o:1, dev:loop4
<7>[ 3471.253687]  disk 4, o:1, dev:loop5
<7>[ 3471.253688]  disk 5, o:1, dev:loop6
<7>[ 3471.253689]  disk 6, o:1, dev:loop7
<3>[ 3475.771451] Buffer I/O error on dev md0, logical block 327680, lost sync page write
<3>[ 3475.771458] JBD2: Error -5 detected when updating journal superblock for md0-8.
<3>[ 3475.771461] Aborting journal on device md0-8.
<3>[ 3475.771471] Buffer I/O error on dev md0, logical block 327680, lost sync page write
<3>[ 3475.771475] JBD2: Error -5 detected when updating journal superblock for md0-8.
<6>[ 3476.104774] md: unbind<loop0>
<6>[ 3476.107402] md: export_rdev(loop0)
<3>[ 3476.459554] Buffer I/O error on dev md0, logical block 0, lost sync page write
<2>[ 3476.459563] EXT4-fs error (device md0): ext4_journal_check_start:56: Detected aborted journal
<2>[ 3476.459567] EXT4-fs (md0): Remounting filesystem read-only
<3>[ 3476.459570] EXT4-fs (md0): previous I/O error to superblock detected
<3>[ 3476.459581] Buffer I/O error on dev md0, logical block 0, lost sync page write
<2>[ 3476.459587] EXT4-fs (md0): ext4_writepages: jbd2_start: 9223372036854775807 pages, ino 12; err -30
<3>[ 3476.495441] EXT4-fs (md0): previous I/O error to superblock detected
<3>[ 3476.495500] Buffer I/O error on dev md0, logical block 0, lost sync page write
<2>[ 3476.495508] EXT4-fs error (device md0): ext4_put_super:837: Couldn't clean up the journal
<6>[ 3476.904587] md: bind<loop0>
<6>[ 3476.919462] md/raid:md0: using device loop0 as journal
<6>[ 3476.919531] md: md0 switched to read-write mode.
<6>[ 3477.317614] EXT4-fs (md0): recovery complete
<6>[ 3477.317618] EXT4-fs (md0): mounted filesystem with ordered data mode. Opts: (null)



Best Regards,
  Yi Zhang


