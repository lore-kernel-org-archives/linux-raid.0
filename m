From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Device kicked from raid too easilly
Date: Sat, 05 Jun 2010 11:21:54 +0930
Message-ID: <1275702714.3740.55.camel@sibyl.beware.dropbear.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think this is different to the similarly titled long thread on SATA
timeouts.

I have an array of U320 scsi disks with similar characteristics from two
different manufacturers.

On two disks I see occasional scsi parity errors. I don't think this is
a cabling or termination issue since I never see the parity errors on
the other brand disks. smartctl shows a number of "non-medium errors"
which I take to be the paroty errors.

Now, when I have a raid 10 of these disks, the scsi parity error causes
the first disk to be failed. The array then continues degraded with no
apparent problems. If I read-add the failed disk, it always fails before
the re-sync is complete. Eg:

Jun  3 23:35:02 fs kernel: md: recovery of RAID array md5
Jun  3 23:35:02 fs kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jun  3 23:35:02 fs kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Jun  3 23:35:02 fs kernel: md: using 128k window, over a total of 29291904 blocks.
Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Sense Key : Aborted Command [current] 
Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] Add. Sense: Scsi parity error
Jun  3 23:35:07 fs kernel: sd 6:0:0:0: [sde] CDB: Write(10): 2a 00 00 05 9e 00 00 01 00 00
Jun  3 23:35:07 fs kernel: end_request: I/O error, dev sde, sector 368128
Jun  3 23:35:07 fs kernel: raid10: Disk failure on sde, disabling device.
Jun  3 23:35:07 fs kernel: raid10: Operation continuing on 3 devices.
Jun  3 23:35:07 fs kernel: md: md5: recovery done.

Now I can test this disk in isolation (using iozone)  pretty heavily and
never see a problem. I can also use it in a raid0 and never see a
problem.

I think some of the strangeness is explained by the comment in the
raid10 error handler:  "else if it is the last working disks, ignore the
error".

Parity errors seem to me like they should be treated as transient
errors. Maybe if there are multiple consecutive parity errors it could
be assumed there is a hard fault in the transport layer. U320 uses
"information units" with (stronger than parity) CRC checking. Although
these errors are not reported as CRC errors that could just be a
reporting issue (the lack of an "additional sense code qualifier").
Given the complexity of the clock recovery de-skewing etc which goes on
for U320, it is not surprising some disks would do it better than
others, but a non zero error rate probably shouldn't be considered
fatal.

I don't really know where this should be fixed. Maybe the scsi layer
should be retrying the scsi command, since it knows most about what sort
of error it is. But equally it could be the responsibility of upper
layers to do any retrying (which gives upper layers the option to not
retry if they don't want to). But if the scsi layer is not responsible
for retrying these sorts of errors, then the md layer is over-reacting
by throwing disks out too easily. 


Regards,
Ian


-- 
Ian Dall <ian@beware.dropbear.id.au>

