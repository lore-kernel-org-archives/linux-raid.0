From: Marc MERLIN <marc@merlins.org>
Subject: How can I ensure that my swraid saves checkpoints with sysrq reboot?
Date: Wed, 12 Sep 2012 09:52:08 -0700
Message-ID: <20120912165208.GA12152@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't have a lot of data on this because each time I get it wrong, I have
to endure 2 days of resync (2TB drives/raid5).

I'm using kernel 3.5.3.

It seems that when my system is having issues and I need to sysrq reboot,
I do:
- sync
- umount
- (re)boot

Last time I did this, all I saw was:
[33415.717023] SysRq : Resetting                                                
[33415.721143] ACPI MEMORY or I/O RESET_REG.  

and sure enough, my raid came back unclean.

Next time, I tried 'o' instead of 'b', and got the following which seems to
sync up my raid checkpoints before shutdown:

Is sysrq-reboot also supposed to sync checkpoints, but just fails to do so
when I'm rebooting due to stuck controller issues anyway?
(note that in this case it's another controller than the one the drives are on)
Or does 'off' sync raid checkpoints and 'reboot' does not?


[  581.511867] SysRq : Power Off
[  581.526466] md: md5: resync done.
[  581.538448] md: checkpointing resync of md5.
[  581.544403] md: delaying resync of md0 until md3 has finished (they share one or more physical units)
[  581.583046] md: md3: resync done.
[  581.669506] md: checkpointing resync of md3.
[  581.675550] md: resync of RAID array md0
[  581.681256] md: minimum _guaranteed_  speed: 40000 KB/sec/disk.
[  581.688938] md: using maximum available idle IO bandwidth (but not more than 81920 KB/sec) for resync.
[  581.699385] md: using 128k window, over a total of 1048512k.
[  581.748192] md: md0: resync done.
[  581.957972] md: checkpointing resync of md0.
[  582.984647] kvm: exiting hardware virtualization
[  583.192431] sd 15:0:0:0: [sdq] Synchronizing SCSI cache
[  583.219673] sd 15:0:0:0: [sdq] Stopping disk
[  583.678907] sd 14:0:0:0: [sdp] Synchronizing SCSI cache
[  583.706855] sd 14:0:0:0: [sdp] Stopping disk
[  584.166092] sd 13:0:0:0: [sdo] Synchronizing SCSI cache
[  584.194037] sd 13:0:0:0: [sdo] Stopping disk
[  584.653278] sd 12:0:0:0: [sdn] Synchronizing SCSI cache
[  584.681225] sd 12:0:0:0: [sdn] Stopping disk
[  585.140459] sd 10:0:0:0: [sdm] Synchronizing SCSI cache
[  585.164369] sd 10:0:0:0: [sdm] Stopping disk
[  585.616919] sd 8:4:0:0: [sdl] Synchronizing SCSI cache
[  585.623818] sd 8:4:0:0: [sdl] Stopping disk
[  586.083546] sd 8:3:0:0: [sdk] Synchronizing SCSI cache
[  586.090333] sd 8:3:0:0: [sdk] Stopping disk
[  586.098364] sd 8:2:0:0: [sdj] Synchronizing SCSI cache
[  586.104642] sd 8:2:0:0: [sdj] Stopping disk
[  586.562706] sd 8:1:0:0: [sdi] Synchronizing SCSI cache
[  586.569474] sd 8:1:0:0: [sdi] Stopping disk
[  586.577436] sd 8:0:0:0: [sdh] Synchronizing SCSI cache
[  586.583685] sd 8:0:0:0: [sdh] Stopping disk
[  586.596304] sd 4:0:1:0: [sdg] Synchronizing SCSI cache
[  586.602869] sd 4:0:1:0: [sdg] Stopping disk
[  586.759081] sd 4:0:0:0: [sdf] Synchronizing SCSI cache
[  586.765676] sd 4:0:0:0: [sdf] Stopping disk
[  586.771551] sd 3:0:0:0: [sde] Synchronizing SCSI cache
[  586.778175] sd 3:0:0:0: [sde] Stopping disk
[  587.219806] sd 2:0:0:0: [sdd] Synchronizing SCSI cache
[  587.263591] sd 2:0:0:0: [sdd] Stopping disk
[  588.024999] sd 1:0:1:0: [sdc] Synchronizing SCSI cache
[  588.064693] sd 1:0:1:0: [sdc] Stopping disk
[  588.826957] sd 0:0:1:0: [sdb] Synchronizing SCSI cache
[  588.833460] sd 0:0:1:0: [sdb] Stopping disk
[  589.258918] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  589.265434] sd 0:0:0:0: [sda] Stopping disk
[  589.690313] r8169 0000:05:00.0: wake-up capability enabled by ACPI
[  589.713372] pcieport 0000:00:01.0: wake-up capability enabled by ACPI


Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
