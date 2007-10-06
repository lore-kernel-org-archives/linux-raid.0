From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 performance issue.
Date: Sat, 6 Oct 2007 04:18:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710060417240.28479@p34.internal.lan>
References: <20071003105321.06943824@zeus.pccl.info> <47069DB9.2050608@redhat.com>
 <20071006003845.0001310238F@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071006003845.0001310238F@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org, blc@redhat.com
List-Id: linux-raid.ids



On Fri, 5 Oct 2007, Dean S. Messing wrote:

>
> Brendan Conoboy wrote:
> <snip>
>> Is the onboard SATA controller real SATA or just an ATA-SATA
>> converter?  If the latter, you're going to have trouble getting faster
>> performance than any one disk can give you at a time.  The output of
>> 'lspci' should tell you if the onboard SATA controller is on its own
>> bus or sharing space with some other device.  Pasting the output here
>> would be useful.
> <snip>
>
> N00bee question:
>
> How does one tell if a machine's disk controller is an ATA-SATA
> converter?
>
> The output of `lspci|fgrep -i sata' is:
>
> 00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA AHCI Controller\
> (rev 09)
>
> suggests a real SATA. These references to ATA in "dmesg", however,
> make me wonder.
>
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-7: WDC WD1600JS-75NCB3, 10.02E04, max UDMA/133
> ata1.00: 312500000 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata2.00: ATA-7: ST3160812AS, 3.ADJ, max UDMA/133
> ata2.00: 312500000 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata2.00: configured for UDMA/133
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: ATA-7: ST3500630NS, 3.AEK, max UDMA/133
> ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata3.00: configured for UDMA/133
>
>
> Dean
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

His drives are either really old and do not support NCQ or he is not using 
AHCI in the BIOS.

Justin.
