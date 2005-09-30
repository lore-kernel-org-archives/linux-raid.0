From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Fri, 30 Sep 2005 12:20:24 -0700
Message-ID: <1128108025.31726.132.camel@seki.nac.uci.edu>
References: <dhje16$tmq$1@sea.gmane.org>  <dhjeja$ve5$1@sea.gmane.org>
	 <1128104924.28664.6.camel@dhcpc226.office.pivotlink.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1128104924.28664.6.camel@dhcpc226.office.pivotlink.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Dameron <brad@seatab.com>
Cc: linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids

On Fri, 2005-09-30 at 11:28 -0700, Brad Dameron wrote:

> http://www.areca.com.tw/products/html/pcix-sata.htm
> 
> Or if you want the best performance you can get with SATA look at this
> one:

Speaking of Areca stuff, someone I'm working with someone who has a
system that appears to be running well with 3.5 terabytes of usable
capacity, But whenever they try to reboot it, it hangs on sync'ing disks
(I haven't seen it first hand yet, but that's what I'm told is
happening).

I haven't tried:

        sync &
        sync &
        sync &
        ...
        reboot(LINUX_REBOOT_CMD_RESTART);

...yet, the last part of which I believe is supposed to reboot without
sync'ing?

Has anyone encountered this before?

Thanks!

Some specifics follow:

Controller info:
        strombrg@hiperstore ~]$ dmesg | grep -i areca
        ARECA RAID: 64BITS PCI BUS DMA ADDRESSING SUPPORTED
        scsi0 : ARECA ARC1130 PCI-X 12 PORTS SATA RAID CONTROLLER
        (RAID6-ENGINE Inside)
          Vendor: Areca     Model: ARC-1130-VOL#00   Rev: R001

CPU info:
        [strombrg@hiperstore ~]$ cat /proc/cpuinfo 
        processor       : 0
        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 5
        model name      : AMD Opteron(tm) Processor 244
        stepping        : 10
        cpu MHz         : 1794.825
        cache size      : 1024 KB
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 1
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep
        mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx
        mmxext lm 3dnowext 3dnow
        bogomips        : 3597.17
        TLB size        : 1024 4K pages
        clflush size    : 64
        cache_alignment : 64
        address sizes   : 40 bits physical, 48 bits virtual
        power management: ts fid vid ttp
        
        processor       : 1
        vendor_id       : AuthenticAMD
        cpu family      : 15
        model           : 5
        model name      : AMD Opteron(tm) Processor 244
        stepping        : 10
        cpu MHz         : 1794.825
        cache size      : 1024 KB
        fpu             : yes
        fpu_exception   : yes
        cpuid level     : 1
        wp              : yes
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep
        mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx
        mmxext lm 3dnowext 3dnow
        bogomips        : 3590.12
        TLB size        : 1024 4K pages
        clflush size    : 64
        cache_alignment : 64
        address sizes   : 40 bits physical, 48 bits virtual
        power management: ts fid vid ttp

OS info:
        [strombrg@hiperstore ~]$ cat /etc/redhat-release 
        Fedora Core release 4 (Stentz)

Kernel info:
        [strombrg@hiperstore ~]$ cat /proc/version 
        Linux version 2.6.13-mm2 (root@hiperstore) (gcc version 4.0.1
        20050727 (Red Hat 4.0.1-5)) #2 SMP Thu Sep 8 23:10:46 PDT 2005

        It appears to be an (otherwise) unmodified Andrew Morton kernel
        they're using:
        
                [strombrg@hiperstore linux-2.6.13-mm2]$ find . -type f -print | egrep -vi '\.ko$|\.cmd$|\.o$' | xargs filetime | highest -n 50
                1126246262      ./drivers/parport/parport.mod.c Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/parport/parport_serial.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/parport/parport_pc.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/message/i2o/i2o_block.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/message/i2o/i2o_config.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/message/i2o/i2o_core.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/message/i2o/i2o_proc.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/message/i2o/i2o_scsi.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/hw/mthca/ib_mthca.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_cm.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_core.mod.c Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_sa.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_ucm.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_mad.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/core/ib_umad.mod.c Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/infiniband/ulp/ipoib/ib_ipoib.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/firestream.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/he.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/horizon.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/idt77252.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/suni.mod.c        Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/ambassador.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/eni.mod.c Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/lanai.mod.c       Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/atm/atmtcp.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/backlight/lcd.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/backlight/backlight.mod.c       Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/vgastate.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/aty/aty128fb.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/aty/radeonfb.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/aty/atyfb.mod.c Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/vga16fb.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/i2c-matroxfb.mod.c       Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_misc.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/g450_pll.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_g450.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_crtc2.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_accel.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_Ti3026.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_maven.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_base.mod.c      Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/matrox/matroxfb_DAC1064.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/savage/savagefb.mod.c   Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/tdfxfb.mod.c    Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/cirrusfb.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/sstfb.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/neofb.mod.c     Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/riva/rivafb.mod.c       Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/macmodes.mod.c  Thu Sep  8 23:11:02 2005
                1126246262      ./drivers/video/kyro/kyrofb.mod.c       Thu Sep  8 23:11:02 2005

        And the arcmsr driver that came with this mm kernel appears to be version " 1.20.00.07    3/23/2005".


