From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: ServeRAID-BR10i (LSI SAS1068E) strageness
Date: Fri, 22 Sep 2017 19:30:15 +1000
Message-ID: <e9659edf-facc-0be5-abe3-23e060bde6ea@eyal.emu.id.au>
References: <74846504-299c-1d75-d6e9-8fbe8b603f52@eyal.emu.id.au>
 <20170922133612.25963e72@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170922133612.25963e72@natsu>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/17 18:36, Roman Mamedov wrote:
> On Fri, 22 Sep 2017 18:11:36 +1000
> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
> 
>> In short, no ata?.00 devices
> 
> This can be normal, one controller I use now is "LSI Logic / Symbios Logic SAS2008 PCI-Express
> Fusion-MPT SAS-2" (mpt3sas driver) and it also does not use the ata devices at all.
> 
> $ ls /sys/block/sd* -la
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sda -> ../devices/pci0000:00/0000:00:11.0/ata1/host1/target1:0:0/1:0:0:0/block/sda
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdb -> ../devices/pci0000:00/0000:00:11.0/ata2/host2/target2:0:0/2:0:0:0/block/sdb
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdc -> ../devices/pci0000:00/0000:00:11.0/ata3/host3/target3:0:0/3:0:0:0/block/sdc
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdd -> ../devices/pci0000:00/0000:00:11.0/ata4/host4/target4:0:0/4:0:0:0/block/sdd
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sde -> ../devices/pci0000:00/0000:00:11.0/ata5/host5/target5:0:0/5:0:0:0/block/sde
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdf -> ../devices/pci0000:00/0000:00:11.0/ata6/host6/target6:0:0/6:0:0:0/block/sdf
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdg -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sdg
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdh -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdh
> lrwxrwxrwx 1 root root 0 Sep 22 13:28 /sys/block/sdi -> ../devices/pci0000:00/0000:00:02.0/0000:01:00.0/host0/port-0:2/end_device-0:2/target0:0:2/0:0:2:0/block/sdi
> 
> 3 disks on the SAS2008 controller.
> 
>> and no 'sdc: sdc1' partition list.
> 
> Did you check if there is the actual /dev/sdc1 present? Tried to access/mount/re-add it to RAID?

Thanks Roman,

Yes, there were no /dev/sd?1 devices, which are the RAID members.

I will install this card again and look around a bit more. I am waiting to hear
if the controller is likely to have touched the disks before testing again.

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
