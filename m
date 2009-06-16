From: Neil Brown <neilb@suse.de>
Subject: Re: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobW9yZSBxdWVzdGlvbnMp?=
Date: Tue, 16 Jun 2009 16:00:37 +1000
Message-ID: <18999.13573.674937.482254@notabene.brown>
References: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
	<200906142101.n5EL1Hpj087478@cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linux-raid.vger.kernel.org@atu.cjb.net on Sunday June 14
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid.vger.kernel.org@atu.cjb.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 14, linux-raid.vger.kernel.org@atu.cjb.net wrote:
> 
> I had tried to add the two old disks (sdi and sdj) while the array was
> in read-only mode for the rebuild, but it didn't allow me.  Is there
> any way to mark the six valid disks as read-only so they will not be
> modified during the rebuild (and not become spares, have their event
> count updated, etc.)?

No.  They won't become spares unless you tell them to, but you cannot
force them to be 100% read-only.

> [ 4421.9] md: md13 switched to read-only mode.
> [ 4549.0] md: md13 switched to read-write mode.
> 
> I again switched back to read-only mode, hoping it would continue
> rebuilding, but it stopped, so I went back to read-write mode and
> it resumed the rebuild.

Yes.  "readonly" means "no writing", including the writing required to
recover or resync the array.

> [ 4628.7] mdadm[19700]: segfault at 0 ip 000000000041617f sp 00007fff87776290 error 4 in mdadm[400000+2a000]
> 
> This new version of mdadm from after my Ubuntu 9.10 upgrade with Linux
> 2.6.28 seg faults every time a new event happens, such as a disk being
> added or removed.  Prior to the upgrade, using Linux 2.6.17 and
> whichever older version of mdadm it had, I had never seen it seg fault.
> 
> # mdadm --version
> 
> mdadm - v2.6.7.1 - 15th October 2008

It would be great if you could get a stack trace of this.  Is the an
"mdadm --monitor" that is dying, or mdadm running for some other
reason?


> [ 4647.7] ata1.00: cmd 61/c0:38:17:43:63/00:00:00:00:00/40 tag 7 ncq 98304 out
> [ 4647.7]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> [ 4647.7] ata1.00: status: { DRDY }
> [ 4647.7] ata1: hard resetting link
> [ 4648.2] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [ 4648.2] ata1.00: configured for UDMA/133
> [ 4648.2] ata1: EH complete
> 
> I've noticed that dmesg most often lists disks as "ata1", "ata9" etc.
> and I have found no way to convert these into /dev/sdc style format.
> Do you know how to translate these disk identifiers?  It's really
> quite frustrating not knowing which disk an error/message is from,
> especially when 2 or 3 disks have issues at the same time.

Sorry, I cannot help you there.
I would probably look in /sys and see if anything looks vaguely similar.

> 
> [ 4648.2] sd 0:0:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
> [ 4648.2] sd 0:0:0:0: [sdi] Write Protect is off
> [ 4648.2] sd 0:0:0:0: [sdi] Mode Sense: 00 3a 00 00
> [ 4648.2] sd 0:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> Proceeding is when I added the last disk back into the set.  I had hoped
> that both disks could rebuild simultaneously, but it seems to force it
> to only rebuild one at a time.  Is there any way to rebuild both disks
> together?  It is frustrating having two idle CPUs during the rebuild,
> and low disk throughput.  I'm guessing mdadm is not a threaded app.

mdadm doesn't do the resync, the kernel does.
It is quite capable of recovering both drives at once, but it is
difficult to tell it to because as soon as you add a drive, it starts
recovery.
What you could do is add both drives, then abort the recovery with
  echo idle > /sys/block/md13/md/sync_action
The recovery will then start again immediately, but using both drives.
A future release of mdadm will 'freeze' the sync action before adding
any drives, then unfreeze afterwards so this will work better in the
future.

> [13696.4] ata5: EH complete
> [13696.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
> [13696.4] sd 4:0:0:0: [sdc] Write Protect is off
> [13696.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [13696.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [13697.4] ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
> [13697.4] ata5.00: irq_stat 0x40000008
> [13697.4] ata5.00: cmd 60/98:28:7f:af:fa/00:00:31:00:00/40 tag 5 ncq 77824 in
> [13697.4]          res 41/40:00:f7:af:fa/09:00:31:00:00/40 Emask 0x409 (media error) <F>
> [13697.4] ata5.00: status: { DRDY ERR }
> [13697.4] ata5.00: error: { UNC }
> [13697.4] ata5.00: configured for UDMA/133
> [13697.4] sd 4:0:0:0: [sdc] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> [13697.4] sd 4:0:0:0: [sdc] Sense Key : Medium Error [current] [descriptor]

"Medium Error" is not good.  It implies you have lost data.  Though it
might be transient due to heat? or something.

> [13697.4] Descriptor sense data with sense descriptors (in hex):
> [13697.4]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [13697.4]         31 fa af f7
> [13697.4] sd 4:0:0:0: [sdc] Add. Sense: Unrecovered read error - auto reallocate failed
> [13697.4] end_request: I/O error, dev sdc, sector 838512631
> [13697.4] raid5:md13: read error not correctable (sector 838512568 on sdc1).
> [13697.4] raid5: Disk failure on sdc1, disabling device.
> [13697.4] raid5: Operation continuing on 5 devices.
> 
> This last line is something I have been baffled by -- how does a RAID-5
> or RAID-6 device continue as "active" when fewer than the minimum number
> of disks is present?  This happened with my RAID-5 swap array losing 2
> disks, and happened above on a RAID-6 with only 5 of 8 disks.  When I
> arrived home, it clearly said the array was still "active".

Just poorly worded messages I guess.  The array doesn't go completely
off-line.  It remains sufficiently active for you to be able to read
any block that isn't on a dead drive.  Possibly there isn't much point
in that. 

> 
> [13697.4] raid5:md13: read error not correctable (sector 838512576 on sdc1).
> [13697.4] raid5:md13: read error not correctable (sector 838512584 on sdc1).
> [13697.4] raid5:md13: read error not correctable (sector 838512592 on sdc1).
> [13697.4] ata5: EH complete
> [13697.4] sd 4:0:0:0: [sdc] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
> [13697.4] sd 4:0:0:0: [sdc] Write Protect is off
> [13697.4] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [13697.4] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [13711.0] md: md13: recovery done.
> 
> What is this "recovery done" referring to?  No recovery was completed.

I just means that it has done all the recovery that it can.  Given the
number of failed devices, that isn't very much.


> 
> I arrived home and performed the following commands
> (I have removed some of the duplicate commands):
> 
> # mdadm --verbose --verbose --detail --scan /dev/md13
> # mdadm --verbose --verbose --detail --scan /dev/md13
> # mdadm /dev/md13 --remove /dev/sdj1 /dev/sdi1
> # mdadm --verbose --verbose --detail --scan /dev/md13
> # mdadm /dev/md13 --remove /dev/sdc1
> # mdadm --verbose --verbose --detail --scan /dev/md13
> # mdadm /dev/md13 --re-add /dev/sdc1

This is where you went wrong.  This will have added /dev/sdc1 as a
spare, because the array was too degraded to have any hope of really
re-adding it.

That is why the metadata on sdc1 no longer reflects its old role in
the array.

Yes: mdadm does need to be improved in this area.

> 
> > As long as there are two missing devices no resync will happen so the
> > data will not be changed.  So after doing a --create you can fsck and
> > mount etc and ensure the data is safe before continuing.
> 
> Thank you, that is useful information.
> 
> Do you know if the data on /dev/sdc1 would be altered as a result of
> it becoming a Spare after it disconnected and reconnected itself?

No, the data will not have been altered.

> 
> > But if you cannot get though a sequential read of all devices without
> > any read error, you wont be able to rebuild redundancy.  (There are
> > plans to make raid6 more robust in this scenario, but they are a long
> > way from fruition yet).
> 
> Prior to attempting the rebuild, I did the following:
> 
> # dd if=/dev/sda1 of=/dev/null &
> # dd if=/dev/sdb1 of=/dev/null &
> # dd if=/dev/sdc1 of=/dev/null &
> # dd if=/dev/sdd1 of=/dev/null &
> # dd if=/dev/sde1 of=/dev/null &
> # dd if=/dev/sdf1 of=/dev/null &
> # dd if=/dev/sdi1 of=/dev/null &
> # dd if=/dev/sdj1 of=/dev/null &
> 
> I left it running for about an hour, and none of the disks had any errors.
> I really hope it is not a permanent fault 75% of the way through the disk.
> Though if it was just bad sectors, why would the disk be disconnecting
> from the system?

Multiple problems I expect.  Maybe something is over-heating or maybe
the controller is a bit dodgey. 

You should be able to create the array with

 mdadm --create /dev/md13 -l6 -n8 missing /dev/sdd1 /dev/sda1 /dev/sdf1 \
                                  missing /dev/sdc1 /dev/sde1 /dev/sdb1
        
providing none of the devices have changed names.  Then you should be
able to get at your data.
You could try a recovery again - it might work.
But if it fails, don't remove and re-add drives that you think have
good data.  Rather stop the array and re-assemble with --force.

NeilBrown
