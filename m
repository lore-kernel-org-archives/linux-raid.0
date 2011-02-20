From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Sun, 20 Feb 2011 14:50:21 -0500
Message-ID: <4D61707D.4040304@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org>	<4D5C4176.80604@gmail.com>	<4D5C4204.5020106@turmel.org>	<1377706586882297883@unknownmsgid>	<4D5C6016.6060809@turmel.org>	<AANLkTi=P5vPKa0JwqcjM3D6u2v9AaK9D35SbJv8Yn+0E@mail.gmail.com>	<4D5D2723.1010101@turmel.org>	<6037962689649361915@unknownmsgid>	<AANLkTik6k7kG1CEj=ESsjUcDJVp58cG_bV4Jx3zrd7LM@mail.gmail.com>	<4D5D52AE.8070602@turmel.org>	<AANLkTi=MZ4vo+H16UMuUsVSA2_D-Wp+sFP-5RqOksjXm@mail.gmail.com
 >	<4D5FE208.5020700@turmel.org>	<AANLkTinOXJWRw_et2U43R_T9XPBzQLnN56Kf2bOAz=_c@mail.gmail.com>	<4D5FED98.6060407@turmel.org> <AANLkTin4u9yk4XPiHzFtagrdV5_iZJZ0+P+yHqH0x9bm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4u9yk4XPiHzFtagrdV5_iZJZ0+P+yHqH0x9bm@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/20/2011 04:56 AM, Simon Mcnair wrote:
> Phil,
> I don't know how to find out if I'm running irqbalance, it's whatever
> was in the proxmox iso that I installed the OS from.  I ran a ps -aux
> | grep irq in case it shows anything of interest:
> 
> proxmox:/home/simon# ps -aux | grep irq
> Warning: bad ps syntax, perhaps a bogus '-'? See http://procps.sf.net/faq.html
> root         3  0.0  0.0      0     0 ?        S    Feb17   0:22 [ksoftirqd/0]
> root         7  0.0  0.0      0     0 ?        S    Feb17   0:05 [ksoftirqd/1]
> root        10  0.0  0.0      0     0 ?        S    Feb17   0:05 [ksoftirqd/2]
> root        13  0.0  0.0      0     0 ?        S    Feb17   0:05 [ksoftirqd/3]
> root        16  0.0  0.0      0     0 ?        S    Feb17   0:11 [ksoftirqd/4]
> root        19  0.0  0.0      0     0 ?        S    Feb17   0:13 [ksoftirqd/5]
> root        22  0.0  0.0      0     0 ?        S    Feb17   0:06 [ksoftirqd/6]
> root        25  0.0  0.0      0     0 ?        S    Feb17   0:06 [ksoftirqd/7]
> root      4024  0.0  0.0      0     0 ?        S    Feb17   0:00
> [kvm-irqfd-clean]

Not there.  On ubuntu 10.10, the package is called "irqbalance", and the executable daemon is "irqbalance".

> proxmox:/home/simon# cat /proc/interrupts
>             CPU0       CPU1       CPU2       CPU3       CPU4
> CPU5       CPU6       CPU7
>    0:   66008972          0          0          0          0
> 0          0          0  IR-IO-APIC-edge      timer
>    1:     265829          0          0          0          0
> 0          0          0  IR-IO-APIC-edge      i8042
>    8:          1          0          0          0          0
> 0          0          0  IR-IO-APIC-edge      rtc0
>    9:          0          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   acpi
>   16:    4432639          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   uhci_hcd:usb3, ahci
>   17:     124325          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   pata_jmicron, eth1
>   18:     954710          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb1,
> uhci_hcd:usb8
>   19:       5994          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   uhci_hcd:usb5,
> uhci_hcd:usb7, firewire_ohci
>   21:          0          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   uhci_hcd:usb4
>   23:         62          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   ehci_hcd:usb2,
> uhci_hcd:usb6
>   24:     273558          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   nvidia
>   28:   30234710          0          0          0          0
> 0          0          0  IR-IO-APIC-fasteoi   mvsas
>   64:          0          0          0          0          0
> 0          0          0  DMAR_MSI-edge      dmar0
>   65:          0          0          0          0          0
> 0          0          0  DMAR_MSI-edge      dmar1
>   73:   26838727          0          0          0          0
> 0          0          0  IR-PCI-MSI-edge      eth0
>   74:   27057631          0          0          0          0
> 0          0          0  IR-PCI-MSI-edge      ahci
>   75:        247          0          0          0          0
> 0          0          0  IR-PCI-MSI-edge      hda_intel
>  NMI:          0          0          0          0          0
> 0          0          0   Non-maskable interrupts
>  LOC:   23087679   23088282   21638323   20580136   22974769
> 20856094   20144310   20084801   Local timer interrupts
>  SPU:          0          0          0          0          0
> 0          0          0   Spurious interrupts
>  PMI:          0          0          0          0          0
> 0          0          0   Performance monitoring interrupts
>  PND:          0          0          0          0          0
> 0          0          0   Performance pending work
>  RES:   15236622    9388860    8532928    7181879   13444866
> 6005599    4856933    3713707   Rescheduling interrupts
>  CAL:       3384       5773       5839       5859       4590
> 5748       5781       5691   Function call interrupts
>  TLB:     201989     195383     193545     196155     251338
> 249053     272032     319233   TLB shootdowns
>  TRM:          0          0          0          0          0
> 0          0          0   Thermal event interrupts
>  THR:          0          0          0          0          0
> 0          0          0   Threshold APIC interrupts
>  MCE:          0          0          0          0          0
> 0          0          0   Machine check exceptions
>  MCP:        830        830        830        830        830
> 830        830        830   Machine check polls
>  ERR:          7
>  MIS:          0

CPU0 is handling every single I/O interrupt.  I really think you need irqbalance.

Phil
