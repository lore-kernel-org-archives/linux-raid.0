From: "Dean S. Messing" <deanm@sharplabs.com>
Subject: Re: RAID 5 performance issue.
Date: Fri,  5 Oct 2007 17:38:45 -0700 (PDT)
Message-ID: <20071006003845.0001310238F@medulla.enet.sharplabs.com>
References: <20071003105321.06943824@zeus.pccl.info> <47069DB9.2050608@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <47069DB9.2050608@redhat.com> (message from Brendan Conoboy on
	Fri, 05 Oct 2007 14:25:29 -0600)
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: blc@redhat.com
List-Id: linux-raid.ids


Brendan Conoboy wrote:
<snip>
> Is the onboard SATA controller real SATA or just an ATA-SATA
> converter?  If the latter, you're going to have trouble getting faster
> performance than any one disk can give you at a time.  The output of
> 'lspci' should tell you if the onboard SATA controller is on its own
> bus or sharing space with some other device.  Pasting the output here
> would be useful.
<snip>

N00bee question: 

How does one tell if a machine's disk controller is an ATA-SATA
converter?

The output of `lspci|fgrep -i sata' is:

00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller\
 (rev 09)

suggests a real SATA. These references to ATA in "dmesg", however,
make me wonder.

 ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 ata1.00: ATA-7: WDC WD1600JS-75NCB3, 10.02E04, max UDMA/133
 ata1.00: 312500000 sectors, multi 0: LBA48 NCQ (depth 31/32)
 ata1.00: configured for UDMA/133
 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
 ata2.00: ATA-7: ST3160812AS, 3.ADJ, max UDMA/133
 ata2.00: 312500000 sectors, multi 0: LBA48 NCQ (depth 31/32)
 ata2.00: configured for UDMA/133
 ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
 ata3.00: ATA-7: ST3500630NS, 3.AEK, max UDMA/133
 ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
 ata3.00: configured for UDMA/133


Dean
