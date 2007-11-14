From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: PROBLEM: raid5 hangs
Date: Wed, 14 Nov 2007 04:07:43 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711140407190.22735@p34.internal.lan>
References: <Pine.LNX.4.64.0711140607160.16327@sysbabe.flashdance.cx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711140607160.16327@sysbabe.flashdance.cx>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Magnusson <iocc@linux-raid.lists.flashdance.cx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a known bug in 2.6.23 and should be fixed in 2.6.23.2 if the RAID5 
bio* patches are applied.

Justin.

On Wed, 14 Nov 2007, Peter Magnusson wrote:

> Hey.
>
> [1.] One line summary of the problem:
>
> raid5 hangs and use 100% cpu
>
> [2.] Full description of the problem/report:
>
> I have used 2.6.18 for 284 days or something until my powersupply died, no 
> problem what so ever duing that time. After that forced reboot I did these 
> changes; Put in 2 GB more memory so I have 3 GB instead of 1 GB, two disks in 
> the raid5 got badblocks so I didnt trust them anymore so I bought new disks 
> (I managed to save the raid5). I have 6x300 GB in a raid5. Two of them are 
> now 320 GB so created a small raid1 also. That raid5 is encrypted with 
> aes-cbc-plain. The raid1 is encrypted with aes-cbc-essiv:sha256.
>
> I compiled linux-2.6.22.3 and started to use that. I used the same .config
> as in default FC5, I think i just selected P4 cpu and preemptive kernel type.
>
> After 11 or 12 days the computer froze, I wasnt home when it happend and
> couldnt fix it for like 3 days. It was just to reboot it as it wasnt possible 
> to login remotely or on console. It did respond to ping however.
> After reboot it rebuilded the raid5.
>
> Then it happend again after approx the same time, 11 or 12 days. I noticed
> that the process md1_raid5 used 100% cpu all the time. After reboot it
> rebuilded the raid5.
>
> I compiled linux-2.6.23.
>
> And then... it happend again... After about the same time as before.
> md1_raid5 used 100% cpu. I also noticed that I wasnt able to save
> anything in my homedir, it froze during save. I could read from it however. 
> My homedir isnt on raid5 but its encrypted. Its not on any disk that has to 
> do with raid. This problem didnt happend when I used 2.6.18. Currently I use 
> 2.6.18 as I kinda need the computer stable.
> After reboot it rebuilded the raid5.
>
> top looked like this:
>
> - 02:37:32 up 11 days,  2:00, 29 users,  load average: 21.06, 17.45, 9.38
> Tasks: 284 total,   2 running, 282 sleeping,   0 stopped,   0 zombie
> Cpu(s):  2.1%us, 51.2%sy,  0.0%ni,  0.0%id, 46.6%wa,  0.0%hi,  0.0%si, 0.0%st
> Mem:   3114928k total,  2981720k used,   133208k free,     8244k buffers
> Swap:  2096472k total,      252k used,  2096220k free,  1690196k cached
>
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 2147 root      15  -5     0    0    0 R  100  0.0  80:25.80 md1_raid5
> 11328 iocc      20   0  536m 374m  28m S    3 12.3 249:32.38 firefox-bin
>
> After some time, just before I rebooted I had this load:
>
> 02:48:36 up 11 days,  2:11, 29 users,  load average: 86.10, 70.80, 40.07
>
> [3.] Keywords (i.e., modules, networking, kernel):
>
> raid5, possible dm_mod
>
> [4.] Kernel version (from /proc/version):
>
> Not using 2.6.23 now but anyway...
> Linux version 2.6.18 (root@flashdance.cx.spamfail) (gcc version 4.1.1 
> 20060525 (Red Hat 4.1.1-1)) #1 SMP Sun Sep 24 12:58:16 CEST 2006
>
> [5.] Output of Oops.. message (if applicable) with symbolic information
>     resolved (see Documentation/oops-tracing.txt)
>
> No oopses, doesnt log anything.
>
> [6.] A small shell script or example program which triggers the
>     problem (if possible)
>
> -
>
> [7.] Environment
>
> Hmm..
>
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/sda1             7.8G  7.0G  761M  91% /	     <- unencrypted fs
> tmpfs                 1.5G     0  1.5G   0% /dev/shm
> /dev/mapper/home       24G   23G  1.6G  94% /home    <- encrypted fs
> /dev/mapper/temp      1.4T  822G  555G  60% /temp    <- encrypted fs,raid5
> /dev/mapper/jb         18G   17G  1.2G  94% /mnt/jb  <- encrypted fs,raid1
>
> [root@flashdance linux-2.6.23]# cryptsetup status home
> /dev/mapper/home is active:
>  cipher:  aes-cbc-plain
>  keysize: 256 bits
>  device:  /dev/sda3
>  offset:  0 sectors
>  size:    50861790 sectors
>  mode:    read/write
> [root@flashdance linux-2.6.23]# cryptsetup status temp
> /dev/mapper/temp is active:
>  cipher:  aes-cbc-plain
>  keysize: 256 bits
>  device:  /dev/md1
>  offset:  0 sectors
>  size:    2930496000 sectors
>  mode:    read/write
> [root@flashdance linux-2.6.23]# cryptsetup status jb
> /dev/mapper/jb is active:
>  cipher:  aes-cbc-essiv:sha256
>  keysize: 256 bits
>  device:  /dev/md0
>  offset:  0 sectors
>  size:    37238528 sectors
>  mode:    read/write
>
> [7.1.] Software (add the output of the ver_linux script here)
>
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>
> Linux flashdance.cx 2.6.18 #1 SMP Sun Sep 24 12:58:16 CEST 2006 i686 i686 
> i386 GNU/Linux
>
> Gnu C                  4.1.1
> Gnu make               3.80
> binutils               2.16.91.0.6
> util-linux             2.13-pre7
> mount                  2.13-pre7
> module-init-tools      3.2.2
> e2fsprogs              1.38
> reiserfsprogs          3.6.19
> quota-tools            3.13.
> PPP                    2.4.3
> Linux C Library        2.4
> Dynamic linker (ldd)   2.4
> Procps                 3.2.7
> Net-tools              1.60
> Kbd                    1.12
> oprofile               0.9.1
> Sh-utils               5.97
> udev                   084
> wireless-tools         28
> Modules Loaded         vfat fat usb_storage cdc_ether usbnet cdc_acm nfs 
> sha256 aes dm_crypt mga_vid iptable_filter ip_tables x_tables nfsd exportfs 
> lockd nfs_acl ipv6 w83627hf hwmon_vid hwmon eeprom i2c_isa sunrpc raid1 
> raid456 xor video button battery asus_acpi ac lp parport_pc parport 
> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul 
> snd_emu10k1 snd_rawmidi snd_ac97_codec snd_ac97_bus snd_seq_dummy snd_seq_oss 
> snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_device 
> snd_timer snd_page_alloc snd_util_mem floppy ehci_hcd sg uhci_hcd emu10k1_gp 
> snd_hwdep matrox_w1 snd e1000 gameport wire soundcore serio_raw cn sata_sil 
> i82875p_edac ata_piix pcspkr i2c_i801 edac_mc dm_snapshot dm_zero dm_mirror 
> dm_mod ext3 jbd sata_promise libata aic7xxx scsi_transport_spi sd_mod 
> scsi_mod
>
> (but its with 2.6.23 that it happends, not 2.6.18..)
>
> [7.2.] Processor information (from /proc/cpuinfo):
>
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 3
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 3
> cpu MHz         : 2998.726
> cache size      : 1024 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe constant_tsc pni 
> monit
> or ds_cpl cid
> bogomips        : 6001.85
>
> processor       : 1
> vendor_id       : GenuineIntel
> cpu family      : 15
> model           : 3
> model name      : Intel(R) Pentium(R) 4 CPU 3.00GHz
> stepping        : 3
> cpu MHz         : 2998.726
> cache size      : 1024 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 1
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 5
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov
> pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe constant_tsc pni 
> monit
> or ds_cpl cid
> bogomips        : 5997.57
>
> [7.3.] Module information (from /proc/modules):
>
> vfat 17152 0 - Live 0xfae23000
> fat 55964 1 vfat, Live 0xfade3000
> usb_storage 73280 0 - Live 0xfadd0000
> cdc_ether 10624 0 - Live 0xfad61000
> usbnet 21768 1 cdc_ether, Live 0xfadc9000
> cdc_acm 20256 0 - Live 0xfadf5000
> nfs 235500 3 - Live 0xfad8e000
> sha256 15616 0 - Live 0xfad81000
> aes 32704 4 - Live 0xfad71000
> dm_crypt 16136 1 - Live 0xfad66000
> mga_vid 18156 0 - Live 0xfad6b000
> iptable_filter 7552 0 - Live 0xfaba7000
> ip_tables 18116 1 iptable_filter, Live 0xfad7b000
> x_tables 18948 1 ip_tables, Live 0xfabb6000
> nfsd 221488 17 - Live 0xfad0d000
> exportfs 10368 1 nfsd, Live 0xfaba3000
> lockd 66568 3 nfs,nfsd, Live 0xfae2c000
> nfs_acl 8192 2 nfs,nfsd, Live 0xfaba0000
> ipv6 266272 122 - Live 0xfacca000
> w83627hf 29968 0 - Live 0xfab97000
> hwmon_vid 7168 1 w83627hf, Live 0xfabac000
> hwmon 7940 1 w83627hf, Live 0xfab52000
> eeprom 11664 0 - Live 0xfabb2000
> i2c_isa 9856 1 w83627hf, Live 0xfab69000
> sunrpc 158908 13 nfs,nfsd,lockd,nfs_acl, Live 0xfaeba000
> raid1 27392 1 - Live 0xfab61000
> raid456 121360 1 - Live 0xfab78000
> xor 19848 1 raid456, Live 0xfab4c000
> video 21252 0 - Live 0xfab45000
> button 11408 0 - Live 0xfab41000
> battery 14852 0 - Live 0xfab3c000
> asus_acpi 21016 0 - Live 0xfab35000
> ac 9860 0 - Live 0xfab55000
> lp 17352 0 - Live 0xfab5b000
> parport_pc 31524 1 - Live 0xfab6f000
> parport 41160 2 lp,parport_pc, Live 0xfabbd000
> snd_emu10k1_synth 12032 0 - Live 0xfaa86000
> snd_emux_synth 39552 1 snd_emu10k1_synth, Live 0xfaab2000
> snd_seq_virmidi 12032 1 snd_emux_synth, Live 0xfaa82000
> snd_seq_midi_emul 10752 1 snd_emux_synth, Live 0xfa94c000
> snd_emu10k1 122016 3 snd_emu10k1_synth, Live 0xfaa25000
> snd_rawmidi 29056 2 snd_seq_virmidi,snd_emu10k1, Live 0xfaa58000
> snd_ac97_codec 95776 1 snd_emu10k1, Live 0xfaa0c000
> snd_ac97_bus 6912 1 snd_ac97_codec, Live 0xfa9fd000
> snd_seq_dummy 8452 0 - Live 0xfa9f9000
> snd_seq_oss 37504 0 - Live 0xfa9ee000
> snd_seq_midi_event 12160 2 snd_seq_virmidi,snd_seq_oss, Live 0xfaa08000
> snd_seq 57456 8 
> snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,s
> nd_seq_oss,snd_seq_midi_event, Live 0xfa9de000
> snd_pcm_oss 46848 1 - Live 0xfa9d1000
> snd_mixer_oss 20992 1 snd_pcm_oss, Live 0xfa9c3000
> snd_pcm 80772 3 snd_emu10k1,snd_ac97_codec,snd_pcm_oss, Live 0xfaa8c000
> snd_seq_device 12940 7 
> snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_rawmidi,
> snd_seq_dummy,snd_seq_oss,snd_seq, Live 0xfa9be000
> snd_timer 27524 3 snd_emu10k1,snd_seq,snd_pcm, Live 0xfa9b6000
> snd_page_alloc 14728 2 snd_emu10k1,snd_pcm, Live 0xfa9a7000
> snd_util_mem 9344 2 snd_emux_synth,snd_emu10k1, Live 0xfa9cd000
> floppy 61732 0 - Live 0xfa996000
> ehci_hcd 35336 0 - Live 0xfa98a000
> sg 38812 0 - Live 0xfa97b000
> uhci_hcd 27916 0 - Live 0xfa971000
> emu10k1_gp 8448 0 - Live 0xfa96b000
> snd_hwdep 13956 2 snd_emux_synth,snd_emu10k1, Live 0xfa966000
> matrox_w1 8704 0 - Live 0xfa986000
> snd 57476 15 
> snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_rawmidi,snd_ac97_cod
> ec,snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_device,snd_time
> r,snd_hwdep, Live 0xfa956000
> e1000 120768 0 - Live 0xfa92d000
> gameport 20360 2 emu10k1_gp, Live 0xfa950000
> wire 28676 1 matrox_w1, Live 0xfa9ad000
> soundcore 14432 2 snd, Live 0xfa906000
> serio_raw 11652 0 - Live 0xfa902000
> cn 13344 1 wire, Live 0xfa8fd000
> sata_sil 16392 4 - Live 0xfa8f5000
> i82875p_edac 11012 0 - Live 0xf885b000
> ata_piix 18440 4 - Live 0xfa8ef000
> pcspkr 7680 0 - Live 0xf8825000
> i2c_i801 12300 0 - Live 0xfa8ea000
> edac_mc 27400 1 i82875p_edac, Live 0xf884a000
> dm_snapshot 21036 0 - Live 0xfa8e3000
> dm_zero 6272 0 - Live 0xf8828000
> dm_mirror 25808 0 - Live 0xf8853000
> dm_mod 61208 10 dm_crypt,dm_snapshot,dm_zero,dm_mirror, Live 0xf8870000
> ext3 134792 4 - Live 0xfa90b000
> jbd 62504 1 ext3, Live 0xf885f000
> sata_promise 16260 0 - Live 0xf882b000
> libata 102292 3 sata_sil,ata_piix,sata_promise, Live 0xfa8c9000
> aic7xxx 143540 3 - Live 0xfa8a4000
> scsi_transport_spi 28928 1 aic7xxx, Live 0xf8841000
> sd_mod 24832 18 - Live 0xf8839000
> scsi_mod 138152 6 usb_storage,sg,libata,aic7xxx,scsi_transport_spi,sd_mod, 
> Live
> 0xfa881000
>
> 00000000-0009fbff : System RAM
>  00000000-00000000 : Crash kernel
> 0009fc00-0009ffff : reserved
> 000a0000-000bffff : Video RAM area
> 000c0000-000c7fff : Video ROM
> 000c8000-000cc7ff : Adapter ROM
> 000cc800-000d27ff : Adapter ROM
> 000f0000-000fffff : System ROM
> 00100000-bff2ffff : System RAM
>  00100000-00324b2d : Kernel code
>  00324b2e-004658ab : Kernel data
> bff30000-bff3ffff : ACPI Tables
> bff40000-bffeffff : ACPI Non-volatile Storage
> bfff0000-bfffffff : reserved
> c4000000-c40fffff : PCI Bus #03
>  c4000000-c407ffff : 0000:03:0b.0
>  c4080000-c408ffff : 0000:03:0c.0
> c4100000-c41003ff : 0000:00:1f.1
> f2a00000-f69fffff : PCI Bus #01
>  f4000000-f5ffffff : 0000:01:00.0
>    f4000000-f5ffffff : matroxfb FB
> f8000000-f9ffffff : 0000:00:00.0
> fab00000-fbbfffff : PCI Bus #01
>  fb000000-fb7fffff : 0000:01:00.0
>  fbbe0000-fbbeffff : 0000:01:00.0
>  fbbfc000-fbbfffff : 0000:01:00.0
>    fbbfc000-fbbfffff : matroxfb MMIO
> fbc00000-fbcfffff : PCI Bus #02
>  fbce0000-fbcfffff : 0000:02:01.0
>    fbce0000-fbcfffff : e1000
> fbd00000-fbefffff : PCI Bus #03
>  fbefe000-fbefefff : 0000:03:0c.0
>    fbefe000-fbefefff : aic7xxx
>  fbeff400-fbeff7ff : 0000:03:0b.0
>    fbeff400-fbeff7ff : sata_sil
> fbfff800-fbfffbff : 0000:00:1d.7
>  fbfff800-fbfffbff : ehci_hcd
> fecf0000-fecf0fff : 0000:00:06.0
> ffb80000-ffffffff : reserved
>
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
>
> 0000-001f : dma1
> 0020-0021 : pic1
> 0040-0043 : timer0
> 0050-0053 : timer1
> 0060-006f : keyboard
> 0070-0077 : rtc
> 0080-008f : dma page reg
> 00a0-00a1 : pic2
> 00c0-00df : dma2
> 00f0-00ff : fpu
> 01f0-01f7 : ide0
> 0290-0297 : pnp 00:0b
>  0295-0296 : w83627hf
> 02f8-02ff : serial
> 0378-037a : parport0
> 037b-037f : parport0
> 03c0-03df : vga+
>  03c0-03df : matrox
> 03f2-03f5 : floppy
> 03f6-03f6 : ide0
> 03f7-03f7 : floppy DIR
> 03f8-03ff : serial
> 0400-041f : 0000:00:1f.3
>  0400-041f : i801_smbus
> 0480-04bf : 0000:00:1f.0
> 0680-06ff : pnp 00:0b
> 0800-087f : 0000:00:1f.0
>  0800-0803 : ACPI PM1a_EVT_BLK
>  0804-0805 : ACPI PM1a_CNT_BLK
>  0808-080b : ACPI PM_TMR
>  0828-082f : ACPI GPE0_BLK
> 0cf8-0cff : PCI conf1
> c000-cfff : PCI Bus #02
>  cf80-cf9f : 0000:02:01.0
>    cf80-cf9f : e1000
> d000-dfff : PCI Bus #03
>  d800-d8ff : 0000:03:0c.0
>  df30-df3f : 0000:03:0b.0
>    df30-df3f : sata_sil
>  df40-df5f : 0000:03:0a.0
>    df40-df5f : EMU10K1
>  df80-df87 : 0000:03:0b.0
>    df80-df87 : sata_sil
>  dfa0-dfa3 : 0000:03:0b.0
>    dfa0-dfa3 : sata_sil
>  dfa4-dfa7 : 0000:03:0b.0
>    dfa4-dfa7 : sata_sil
>  dfa8-dfaf : 0000:03:0b.0
>    dfa8-dfaf : sata_sil
>  dfe0-dfe7 : 0000:03:0a.1
>    dfe0-dfe7 : emu10k1-gp
> eec0-eedf : 0000:00:1d.0
>  eec0-eedf : uhci_hcd
> ef00-ef1f : 0000:00:1d.1
>  ef00-ef1f : uhci_hcd
> ef20-ef3f : 0000:00:1d.2
>  ef20-ef3f : uhci_hcd
> ef40-ef5f : 0000:00:1d.3
>  ef40-ef5f : uhci_hcd
> ef90-ef9f : 0000:00:1f.2
>  ef90-ef9f : libata
> efa0-efa7 : 0000:00:1f.2
>  efa0-efa7 : libata
> efa8-efab : 0000:00:1f.2
>  efa8-efab : libata
> efac-efaf : 0000:00:1f.2
>  efac-efaf : libata
> efe0-efe7 : 0000:00:1f.2
>  efe0-efe7 : libata
> fc00-fc0f : 0000:00:1f.1
>  fc00-fc07 : ide0
>  fc08-fc0f : ide1
>
> [7.5.] PCI information ('lspci -vvv' as root)
>
> 00:00.0 Host bridge: Intel Corporation 82875P/E7210 Memory Controller Hub 
> (rev 02)
>        Subsystem: ASUSTeK Computer Inc. Unknown device 80f6
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort+ >SERR- <PERR-
>        Latency: 0
>        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=32M]
>        Capabilities: [e4] Vendor Specific Information
>        Capabilities: [a0] AGP version 3.0
>                Status: RQ=32 Iso- ArqSz=2 Cal=0 SBA+ ITACoh- GART64- HTrans- 
> 64bit- FW+ AGP3- Rate=x1,x2,x4
>                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- 
> Rate=x1
>
> 00:01.0 PCI bridge: Intel Corporation 82875P Processor to AGP Controller (rev 
> 02) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64
>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>        I/O behind bridge: 0000f000-00000fff
>        Memory behind bridge: fab00000-fbbfffff
>        Prefetchable memory behind bridge: f2a00000-f69fffff
>        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
>
> 00:03.0 PCI bridge: Intel Corporation 82875P/E7210 Processor to PCI to CSA 
> Bridge (rev 02) (prog-if 00 [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64
>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>        I/O behind bridge: 0000c000-0000cfff
>        Memory behind bridge: fbc00000-fbcfffff
>        Prefetchable memory behind bridge: fff00000-000fffff
>        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- <SERR- <PERR-
>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>
> 00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
> Controller #1 (rev 02) (prog-if 00 [UHCI])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 169
>        Region 4: I/O ports at eec0 [size=32]
>
> 00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
> Controller #2 (rev 02) (prog-if 00 [UHCI])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin B routed to IRQ 217
>        Region 4: I/O ports at ef00 [size=32]
>
> 00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
> Controller #3 (rev 02) (prog-if 00 [UHCI])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin C routed to IRQ 177
>        Region 4: I/O ports at ef20 [size=32]
>
> 00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
> Controller #4 (rev 02) (prog-if 00 [UHCI])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 169
>        Region 4: I/O ports at ef40 [size=32]
>
> 00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI 
> Controller (rev 02) (prog-if 20 [EHCI])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin D routed to IRQ 201
>        Region 0: Memory at fbfff800 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [50] Power Management version 2
>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [58] Debug port
>
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 00 
> [Normal decode])
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
>        I/O behind bridge: 0000d000-0000dfff
>        Memory behind bridge: fbd00000-fbefffff
>        Prefetchable memory behind bridge: c4000000-c40fffff
>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort+ <SERR- <PERR-
>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>
> 00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface 
> Bridge (rev 02)
>        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>
> 00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
> Controller (rev 02) (prog-if 8a [Master SecP PriP])
>        Subsystem: ASUSTeK Computer Inc. P5P800-MX Mainboard
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 177
>        Region 0: I/O ports at <unassigned>
>        Region 1: I/O ports at <unassigned>
>        Region 2: I/O ports at <unassigned>
>        Region 3: I/O ports at <unassigned>
>        Region 4: I/O ports at fc00 [size=16]
>        Region 5: Memory at c4100000 (32-bit, non-prefetchable) [size=1K]
>
> 00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 
> 02) (prog-if 8f [Master SecP SecO PriP PriO])
>        Subsystem: ASUSTeK Computer Inc. P4P800 SE Mainboard
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0
>        Interrupt: pin A routed to IRQ 177
>        Region 0: I/O ports at efe0 [size=8]
>        Region 1: I/O ports at efac [size=4]
>        Region 2: I/O ports at efa0 [size=8]
>        Region 3: I/O ports at efa8 [size=4]
>        Region 4: I/O ports at ef90 [size=16]
>
> 00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller 
> (rev 02)
>        Subsystem: ASUSTeK Computer Inc. P4P800 Mainboard
>        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Interrupt: pin B routed to IRQ 193
>        Region 4: I/O ports at 0400 [size=32]
>
> 01:00.0 VGA compatible controller: Matrox Graphics, Inc. G400/G450 (rev 03) 
> (prog-if 00 [VGA])
>        Subsystem: Matrox Graphics, Inc. Millennium G400 MAX/Dual Head 32Mb
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64 (4000ns min, 8000ns max), Cache Line Size 04
>        Interrupt: pin A routed to IRQ 169
>        Region 0: Memory at f4000000 (32-bit, prefetchable) [size=32M]
>        Region 1: Memory at fbbfc000 (32-bit, non-prefetchable) [size=16K]
>        Region 2: Memory at fb000000 (32-bit, non-prefetchable) [size=8M]
>        Expansion ROM at fbbe0000 [disabled] [size=64K]
>        Capabilities: [dc] Power Management version 2
>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>        Capabilities: [f0] AGP version 2.0
>                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
> 64bit- FW- AGP3- Rate=x1,x2
>                Command: RQ=32 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- 
> Rate=x1
>
> 02:01.0 Ethernet controller: Intel Corporation 82547EI Gigabit Ethernet 
> Controller (LOM)
>        Subsystem: ASUSTeK Computer Inc. Unknown device 80f7
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 0 (63750ns min), Cache Line Size 04
>        Interrupt: pin A routed to IRQ 177
>        Region 0: Memory at fbce0000 (32-bit, non-prefetchable) [size=128K]
>        Region 2: I/O ports at cf80 [size=32]
>        Capabilities: [dc] Power Management version 2
>                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>
> 03:0a.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 0a)
>        Subsystem: Creative Labs SBLive! 5.1 Digital Model SB0220
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64 (500ns min, 5000ns max)
>        Interrupt: pin A routed to IRQ 209
>        Region 0: I/O ports at df40 [size=32]
>        Capabilities: [dc] Power Management version 1
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 03:0a.1 Input device controller: Creative Labs SB Live! MIDI/Game Port (rev 
> 0a)
>        Subsystem: Creative Labs Gameport Joystick
>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64
>        Region 0: I/O ports at dfe0 [size=8]
>        Capabilities: [dc] Power Management version 1
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>
> 03:0b.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] 
> Serial ATA Controller (rev 02)
>        Subsystem: Silicon Image, Inc. SiI 3114 SATARaid Controller
>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64, Cache Line Size 04
>        Interrupt: pin A routed to IRQ 201
>        Region 0: I/O ports at dfa8 [size=8]
>        Region 1: I/O ports at dfa4 [size=4]
>        Region 2: I/O ports at df80 [size=8]
>        Region 3: I/O ports at dfa0 [size=4]
>        Region 4: I/O ports at df30 [size=16]
>        Region 5: Memory at fbeff400 (32-bit, non-prefetchable) [size=1K]
>        Expansion ROM at c4000000 [disabled] [size=512K]
>        Capabilities: [60] Power Management version 2
>                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>
> 03:0c.0 SCSI storage controller: Adaptec AHA-2940U/UW/D / AIC-7881U
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
> Stepping- SERR+ FastB2B-
>        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>        Latency: 64 (2000ns min, 2000ns max), Cache Line Size 04
>        Interrupt: pin A routed to IRQ 185
>        Region 0: I/O ports at d800 [disabled] [size=256]
>        Region 1: Memory at fbefe000 (32-bit, non-prefetchable) [size=4K]
>        Expansion ROM at c4080000 [disabled] [size=64K]
>
> [7.6.] SCSI information (from /proc/scsi/scsi)
>
> Attached devices:
> Host: scsi0 Channel: 00 Id: 10 Lun: 00
>  Vendor: MAXTOR   Model: ATLAS10K4_36WLS  Rev: DFL0
>  Type:   Direct-Access                    ANSI SCSI revision: 03
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: SAMSUNG HD321KJ  Rev: CP10
>  Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi2 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: SAMSUNG HD321KJ  Rev: CP10
>  Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi3 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: Maxtor 6V300F0   Rev: VA11
>  Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi4 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: Maxtor 6V300F0   Rev: VA11
>  Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi5 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: Maxtor 6V300F0   Rev: VA11
>  Type:   Direct-Access                    ANSI SCSI revision: 05
> Host: scsi6 Channel: 00 Id: 00 Lun: 00
>  Vendor: ATA      Model: Maxtor 6V300F0   Rev: VA11
>  Type:   Direct-Access                    ANSI SCSI revision: 05
>
> [7.7.] Other information that might be relevant to the problem
>       (please look in /proc and include all information that you
>       think to be relevant):
>
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1]
> md1 : active raid5 sdg1[1] sdf1[0] sde1[2] sdd1[3] sdc1[5] sdb1[4]
>      1465248000 blocks level 5, 256k chunk, algorithm 2 [6/6] [UUUUUU]
>
> md0 : active raid1 sdc2[1] sdb2[0]
>      18619264 blocks [2/2] [UU]
>
> [X.] Other notes, patches, fixes, workarounds:
>
> crypto could be related to this problem, but Im not sure.
> If it helps I can boot 2.6.23 to get the correct /proc/version and
> stuff like that. Has anyone else reported a problem like this?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
