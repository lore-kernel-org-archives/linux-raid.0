From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Read errors and SMART tests
Date: Sat, 20 Dec 2008 12:00:44 +1030
Message-ID: <20081220013043.GM1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Just a quick question about SMART tests :-

I have a Samsung drive returning read errors, e.g.:

Dec 20 08:59:24 hermes kernel: ata4.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Dec 20 08:59:24 hermes kernel: ata4.00: irq_stat 0x40000008
Dec 20 08:59:24 hermes kernel: ata4.00: cmd 60/80:00:3f:0e:50/00:00:24:00:00/40 tag 0 ncq 65536 in
Dec 20 08:59:24 hermes kernel:          res 41/40:00:61:0e:50/00:00:24:00:00/40 Emask 0x409 (media error) <F>
Dec 20 08:59:24 hermes kernel: ata4.00: status: { DRDY ERR }
Dec 20 08:59:24 hermes kernel: ata4.00: error: { UNC }
Dec 20 08:59:24 hermes kernel: ata4.00: configured for UDMA/133
Dec 20 08:59:24 hermes kernel: ata4: EH complete
Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Write Protect is off
Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

So, I ran the short (and long) selftest and it showed read
failures. Then I put in a new drive to replace it and ran the short
selftest again - this one is showing read errors also:

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision number = 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       20%      2572         294961
# 2  Short offline       Aborted by host               20%      2572         -

I'm guessing this is just bad luck, i.e. drives from the same bad
batch. Erm, so my question - Am I right in assuming that the SMART
self test is not influenced in any way by bad cables, etc.? If the
drive returns read errors on it's self-test the error is within the
drive itself, right?

Thanks,
Kevin.
