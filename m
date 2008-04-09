From: "Christian Pernegger" <pernegger@gmail.com>
Subject: drive failed, need help with interpretation / recovery
Date: Wed, 9 Apr 2008 19:05:31 +0200
Message-ID: <bb145bd20804091005x1ce30fmea001a9ff7d2307e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Found an e-mail from mdam in my inbox and this in the logs:

Apr  8 04:44:50 jesus kernel: ata3.00: exception Emask 0x0 SAct 0x1
SErr 0x0 action 0x2 frozen
Apr  8 04:44:50 jesus kernel: ata3.00: cmd
60/00:00:00:6c:ef/01:00:2c:00:00/40 tag 0 cdb 0x0 data 131072 in
Apr  8 04:44:50 jesus kernel:          res
40/00:00:00:00:02/00:00:00:00:00/00 Emask 0x4 (timeout)
Apr  8 04:44:51 jesus kernel: ata3: soft resetting port
Apr  8 04:45:01 jesus kernel: ata3: softreset failed (timeout)
Apr  8 04:45:01 jesus kernel: ata3: hard resetting port
Apr  8 04:45:11 jesus kernel: ata3: softreset failed (timeout)
Apr  8 04:45:11 jesus kernel: ata3: hard resetting port
Apr  8 04:45:46 jesus kernel: ata3: softreset failed (timeout)
Apr  8 04:45:46 jesus kernel: ata3: hard resetting port
Apr  8 04:45:51 jesus kernel: ata3: softreset failed (timeout)
Apr  8 04:45:51 jesus kernel: ata3: reset failed, giving up
Apr  8 04:45:51 jesus kernel: ata3.00: disabled
Apr  8 04:45:51 jesus kernel: ata3: EH complete
Apr  8 04:45:51 jesus kernel: sd 3:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr  8 04:45:51 jesus kernel: end_request: I/O error, dev sdd, sector 753888256
Apr  8 04:45:51 jesus kernel: sd 3:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr  8 04:45:51 jesus kernel: end_request: I/O error, dev sdd, sector 753888256
Apr  8 04:45:51 jesus kernel: raid5: Disk failure on sdd, disabling
device. Operation continuing on 3 devices
Apr  8 04:45:51 jesus kernel: RAID5 conf printout:
Apr  8 04:45:51 jesus kernel:  --- rd:4 wd:3
Apr  8 04:45:51 jesus kernel:  disk 0, o:1, dev:sdb
Apr  8 04:45:51 jesus kernel:  disk 1, o:1, dev:sdc
Apr  8 04:45:51 jesus kernel:  disk 2, o:0, dev:sdd
Apr  8 04:45:51 jesus kernel:  disk 3, o:1, dev:sde
Apr  8 04:45:51 jesus kernel: RAID5 conf printout:
Apr  8 04:45:51 jesus kernel:  --- rd:4 wd:3
Apr  8 04:45:51 jesus kernel:  disk 0, o:1, dev:sdb
Apr  8 04:45:51 jesus kernel:  disk 1, o:1, dev:sdc
Apr  8 04:45:51 jesus kernel:  disk 3, o:1, dev:sde

---

Apr  9 17:46:08 jesus kernel: md: unbind<sdd>
Apr  9 17:46:08 jesus kernel: md: export_rdev(sdd)
Apr  9 17:47:24 jesus kernel: sd 3:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr  9 17:47:24 jesus kernel: end_request: I/O error, dev sdd, sector 976773152
Apr  9 17:47:24 jesus kernel: Buffer I/O error on device sdd, logical
block 122096644
Apr  9 17:47:25 jesus kernel: sd 3:0:0:0: [sdd] Result:
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Apr  9 17:47:25 jesus kernel: end_request: I/O error, dev sdd, sector 976773152
Apr  9 17:47:25 jesus kernel: Buffer I/O error on device sdd, logical
block 122096644
[... lots more ...]

The first part is what was originally there. Here's what I did:

I --remove'd the drive, which went fine. Any further attempts to
access the drive, be it for a simple --(re-)add, --zero-superblock or
badblocks -w failed with the above errors.

At which point I shut down the machine to replace the drive but
restarted it instead by mistake - lo and behold, the drive is back and
working.
Re-adding it to the array went flawlessly and only took a few seconds
of recovery. (Might well be that there were no writes in the last few
days.)

BUT considering I already tried to zero the superblock and run a
destructive badblocks test - can I be sure that none of these commands
went through and the data and superblock on the intermittent disk are
ok? I started a "check" just to be sure, no errors yet, but I don't
know if it will pick up all errors, i. e. in the superblock or other
non-payload areas.

Should I
- fail the disk again manually, wipe it and force a full resync, with
the added risk of another disk going on holiday or
- let the "check" run its course and leave the disk as-is if
mismatch_cnt remains 0?

As for the failiure itself, maybe the dreaded
WD5000YS-drops-out-of-RAIDs-intermittently bug has finally bitten me
... I'm guessing I should exchange the disk just to be on the safe
side?

Thanks,

C.
