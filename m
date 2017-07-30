From: Alex <mysqlstudent@gmail.com>
Subject: RecovData Handshk error
Date: Sat, 29 Jul 2017 21:54:42 -0400
Message-ID: <CAB1R3shnsVV2bnkiF2q-X+9iHD0eUrS0Xq0hqWgWM+EQAUwFXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have a fedora25 system with a MegaRAID SAS 9260-8i. I believe
there's 8 500GB SSDs connected. It appears one (or more?) may be
having a problem. I'm now noticing this message periodically in the
kernel logs:

[Wed Jun 28 01:40:06 2017] ata1.00: exception Emask 0x0 SAct 0x0 SErr
0x400001 action 0x6 frozen
[Wed Jun 28 01:40:06 2017] ata1: SError: { RecovData Handshk }
[Wed Jun 28 01:40:06 2017] ata1.00: cmd
a0/00:00:00:08:00/00:00:00:00:00/a0 tag 29 pio 16392 in
                                    Get event status notification 4a
01 00 00 10 00 00 00 08 00res 40/00:00:00:00:00/00:00:00:00:00/00
Emask 0x4 (timeout)
[Wed Jun 28 01:40:06 2017] ata1.00: status: { DRDY }
[Wed Jun 28 01:40:06 2017] ata1: hard resetting link
[Wed Jun 28 01:40:06 2017] ata1: SATA link up 1.5 Gbps (SStatus 113
SControl 300)
[Wed Jun 28 01:40:06 2017] ata1.00: configured for UDMA/133
[Wed Jun 28 01:40:06 2017] ata1: EH complete

Is it something to be concerned with? What level of panic? :-)

It appears to recover normally? Is it a device or disk issue? How can
I identify which disk is involved?

This is the information on the control from lspci:

05:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
2108 [Liberator] (rev 05)
        Subsystem: LSI Logic / Symbios Logic MegaRAID SAS 9260-8i
        Flags: bus master, fast devsel, latency 0, IRQ 29, NUMA node 0
        I/O ports at 7000 [size=256]
        Memory at df960000 (64-bit, non-prefetchable) [size=16K]
        Memory at df900000 (64-bit, non-prefetchable) [size=256K]
        Expansion ROM at df940000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 3
        Capabilities: [68] Express Endpoint, MSI 00
        Capabilities: [d0] Vital Product Data
        Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [c0] MSI-X: Enable+ Count=15 Masked-
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [138] Power Budgeting <?>
        Kernel driver in use: megaraid_sas
        Kernel modules: megaraid_sas

Thanks for any ideas.
