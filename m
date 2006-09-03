From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Kernel RAID support
Date: Sun, 03 Sep 2006 16:36:49 +1200
Message-ID: <44FA5BE1.1080706@sauce.co.nz>
References: <44FA5261.4010207@sauce.co.nz> <1157256114.10326.0.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1157256114.10326.0.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Josh Litherland wrote:
> On Sun, 2006-09-03 at 15:56 +1200, Richard Scobie wrote:
> 
>>I am building  2.6.18rc5-mm1 and I cannot find the entry under "make 
>>config", to enable the various RAID options.
> 
> 
> Under "Device Drivers", switch on "Multi-device support".
> 

Thanks. I must be going nuts, as it does not appear as an option. Below 
is the list under "Device Drivers" if I do a "make menuconfig":

         Generic Driver Options  --->                                 x x
   x x        Connector - unified userspace <-> kernelspace linker  ---> 
   x x
   x x        Memory Technology Devices (MTD)  ---> 
    x x
   x x        Parallel port support  ---> 
    x x
   x x        Plug and Play support  ---> 
    x x
   x x        Block devices  ---> 
    x x
   x x        ATA/ATAPI/MFM/RLL support  ---> 
    x x
   x x        SCSI device support  ---> 
    x x
   x x        Serial ATA (prod) and Parallel ATA (experimental) drivers 
  --x x
   x x        Fusion MPT device support  ---> 
    x x
   x x        IEEE 1394 (FireWire) support  ---> 
    x x
   x x        I2O device support  ---> 
    x x
   x x        Network device support  ---> 
    x x
   x x        ISDN subsystem  ---> 
    x x
   x x        Telephony Support  ---> 
    x x
   x x        Input device support  ---> 
    x x
   x x        Character devices  ---> 
    x x
   x x        I2C support  ---> 
    x x
   x x        SPI support  ---> 
    x x
   x x        Dallas's 1-wire bus  ---> 
    x x
   x x        Hardware Monitoring support  ---> 
    x x
   x x        Misc devices  ---> 
    x x
   x x        Multimedia devices  ---> 
    x x
   x x        Graphics support  ---> 
    x x
   x x        Sound  ---> 
    x x
   x x        USB support  ---> 
    x x
   x x        MMC/SD Card support  ---> 
    x x
   x x        LED devices  ---> 
    x x
   x x        InfiniBand support  ---> 
    x x
   x x        EDAC - error detection and reporting (RAS) (EXPERIMENTAL) 
  --x x
   x x        Real Time Clock  ---> 
    x x
   x x        DMA Engine support  ---> 
    x x
   x x        Industrial IO  --->

Regards,

Richard

-- 
VGER BF report: U 0.50156
