From: Neil Brown <neilb@suse.de>
Subject: Re: md and sd out of sync
Date: Mon, 5 Jul 2010 10:05:17 +1000
Message-ID: <20100705100517.77515870@notabene.brown>
References: <4C310A61.1020209@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C310A61.1020209@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 05 Jul 2010 10:25:37 +1200
Richard Scobie <richard@sauce.co.nz> wrote:

> I have 16 x 2TB drives that each partitioned into 3 equal sized partitions.
> 
> Three md RAID6 arrays have then been built, each utilising one partition 
> on each drive.
> 
> Over the weekend, one member of one array was failed out:
> 
> end_request: I/O error, dev sdz, sector 1302228737
> md: super_written gets error=-5, uptodate=0
> raid5: Disk failure on sdz1, disabling device.
> raid5: Operation continuing on 15 devices.
> 
> Checking with smartctl is not an option as the controller (LSI SAS) 
> reacts badly. On the basis of it possibly being a transitory error or a 
> sector that could be remapped on resync I re-added it to the array.
> 
> This failed part way through and cased enough disruption to the 
> controller that the whole drive was taken offline:
> 
> sd 8:0:24:0: [sdz] <6>sd 8:0:24:0: [sdz] Result: hostbyte=DID_NO_CONNECT 
> driverb
> yte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdz, sector 569772337
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdz, sector 569769777
> sd 8:0:24:0: [sdz] <6>mptsas: ioc0: removing sata device, channel 0, id 
> 32, phy
> 11
> Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdz, sector 569770097
>   port-8:1:8: mptsas: ioc0: delete port (8)
> 
> 
> I would have thought at this point for mdadm to be reporting that the 
> remaining 2 complete arrays had each lost their /dev/sdz components, but 
> this is not the case - it shows healthy arrays.
> 
> Is this expected behaviour?

Yes.  md only notices that a device has failed when it tried to perform IO
and gets an error.

The next release of mdadm will have "mdadm -incremental --fail" which can be
called by udev when udev notices a device disappearing.  mdadm will find any
array that included the given device and fail/remove it.

> 
> To complicate things further, without any intervention, the disconnected 
> drive was then recognised again as a new device and reconnected as 
> /dev/sdai:
> 
> mptsas: ioc0: attaching sata device, channel 0, id 32, phy 11
> scsi 8:0:34:0: Direct-Access     ATA      WDC WD2003FYYS-0 0D02 PQ: 0 
> ANSI: 5
> sd 8:0:34:0: [sdai] 3907029168 512-byte hardware sectors (2000399 MB)
> sd 8:0:34:0: [sdai] Write Protect is off
> sd 8:0:34:0: [sdai] Mode Sense: 73 00 00 08
> sd 8:0:34:0: [sdai] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 8:0:34:0: [sdai] 3907029168 512-byte hardware sectors (2000399 MB)
> sd 8:0:34:0: [sdai] Write Protect is off
> sd 8:0:34:0: [sdai] Mode Sense: 73 00 00 08
> sd 8:0:34:0: [sdai] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
>   sdai: sdai1 sdai2 sdai3
> sd 8:0:34:0: [sdai] Attached SCSI disk
> sd 8:0:34:0: Attached scsi generic sg26 type 0
> 
> 
> Because sdz no longer exists, I cannot fail and remove /dev/sdz2 and 
> /dev/sdz3 from the other 2 md arrays.

You can.
  mdadm /dev/mdXX --fail detached
  mdadm /dev/mdXX --remove detached

NeilBrown


> 
> I will proceed by just replacing the drive and rebooting, at which point 
> I should just be able to re-add it to all arrays, but I just wanted to 
> draw attention to how ignorant md seems to be to all the changes that 
> have occurred. Maybe things have changed in later versions:
> 
> Kernel 2.6.27.19-78.2.30.fc9.x86_64
> mdadm 2.6.4
> 
> Regards,
> 
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

