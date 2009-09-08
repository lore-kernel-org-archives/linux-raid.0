From: "Majed B." <majedb@gmail.com>
Subject: Re: Adaptec 1430SA
Date: Wed, 9 Sep 2009 02:08:15 +0300
Message-ID: <70ed7c3e0909081608w4c2e899dw8e3815bf4aea6d5c@mail.gmail.com>
References: <316071.56440.qm@web51305.mail.re2.yahoo.com> <6c4602af0909081530h3bde17afy2435de130a5a77ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c4602af0909081530h3bde17afy2435de130a5a77ff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBQcnp5xYJ1c2tp?= <mikylie@gmail.com>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It would be nice if you guys posted your reviews in the Hardware
Compatibility List reviews: http://www.linuxquestions.org/hcl/

It would help many others :)

2009/9/9 Micha=C5=82 Przy=C5=82uski <mikylie@gmail.com>:
> Hello,
> I am using Adaptec 1430SA. I chose it because it was the only:
> * reasonably priced (no hw raid),
> * >2 port controller,
> * pci-e faster than x1.
>
> From bad news, I cannot access its "configuration utility" during
> startup, just as Ryan mentioned. I'm using Asus P5K-E (P35 chipset),
> and 1430SA lives in non-gfx pci-e slot. I don't cry though, I never
> wanted to use its fakeraid for anything.
>
> I'm running 2.6.23-0.214.rc8.git2.fc8 and currently only a WD10EADS i=
s
> hooked up to the 1430SA. I'm using sata_mv driver, and it looks more
> or less like this:
>
> sata_mv 0000:04:00.0: version 1.0
> ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> sata_mv 0000:04:00.0: Applying 60X1C0 workarounds to unknown rev
> sata_mv 0000:04:00.0: Gen-IIE 32 slots 4 ports ? mode IRQ via INTx
> PCI: Setting latency timer of device 0000:04:00.0 to 64
> scsi10 : sata_mv
> scsi11 : sata_mv
> scsi12 : sata_mv
> scsi13 : sata_mv
> ata11: SATA max UDMA/133 cmd 0x0000000000000000 ctl 0xffffc20002fa212=
0
> bmdma 0x0000000000000000 irq 16
> ata12: SATA max UDMA/133 cmd 0x0000000000000000 ctl 0xffffc20002fa412=
0
> bmdma 0x0000000000000000 irq 16
> ata13: SATA max UDMA/133 cmd 0x0000000000000000 ctl 0xffffc20002fa612=
0
> bmdma 0x0000000000000000 irq 16
> ata14: SATA max UDMA/133 cmd 0x0000000000000000 ctl 0xffffc20002fa812=
0
> bmdma 0x0000000000000000 irq 16
> ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata11.00: ATA-8: WDC WD10EADS-00M2B0, 01.00A01, max UDMA/133
> ata11.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 0/32)
> ata11.00: configured for UDMA/133
> ata12: SATA link down (SStatus 0 SControl 300)
> ata13: SATA link down (SStatus 0 SControl 300)
> ata14: SATA link down (SStatus 0 SControl 300)
> scsi 10:0:0:0: Direct-Access =C2=A0 =C2=A0 ATA =C2=A0 =C2=A0 =C2=A0WD=
C WD10EADS-00M 01.0 PQ: 0 ANSI: 5
> sd 10:0:0:0: [sdh] 1953525168 512-byte hardware sectors (1000205 MB)
> ...
>
> Initially I was worried about
> sata_mv 0000:04:00.0: Applying 60X1C0 workarounds to unknown rev
> sata_mv 0000:04:00.0: Gen-IIE 32 slots 4 ports ? mode IRQ via INTx
> because support for 1430SA was added just around 2.6.23, so it seems
> my kernel doesn't really recognise it correctly (should be 7-somethin=
g
> chip). I was worried about some data corruption with sata_mv (that
> I've just read about) but both issues turned out to be no problem. It
> works perfectly and I've not encountered any corruption across 1TB of
> md5'ed files. I suggest using newer kernel though.
>
> So to sum up, I found it good value for money with no real drawbacks.
>
> Cheers,
> Mike
>
> 2009/9/8 Jon Hardcastle <jd_hardcastle@yahoo.com>:
>> Does anyone have any experience with Adaptec controllers? Namely
>>
>> http://www.adaptec.com/en-US/support/sata/sataii/AAR-1430SA/
>>
>> I want to increase my machines drive capacity and reply the existing=
 2 port pci-e with this bad boy.
>>
>> Also; any ideas of a good price? Have seen for ~=C2=A370 + p&p
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
