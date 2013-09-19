From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Moving drives around for a new one
Date: Thu, 19 Sep 2013 02:14:06 -0700
Message-ID: <523AC05E.90709@vorgon.com>
References: <5233A75D.5030007@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5233A75D.5030007@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

No one can answer??

On 9/13/2013 5:01 PM, Timothy D. Lenz wrote:
> I currently have 4 500Gb drives. sda/b are mirrored with 3 arrays:
>
> md0 is boot, os, and some misc stuff.
> md1 is swap
> md2 is data.
>
> sdc/d is one mirrored array, md3
>
> sdc is failing. SMART is now reporting ~150 bad sectors but mdadm hasn't
> kicked it out yet. I have a Hitachi 0A39289 Ultrastar A7K2000 on order.
> I am hoping that it is not short changed on size compaired to the 2
> segates or it won't have enough space. But I want it to be mirrored into
> all 4 arrays basicly becoming a 3rd mirror for md0/1/2 and one of 2 for
> md3. At some point I want to get a second 1TB and get it down to just
> the 2 drives. Then I can remove md3 and expand md2.
>
> What I'd like to do is after removing sdc, move sda/b down one on the
> motherboard connectors so that the new drive is sda. There is at least 1
> file I know needs to be updated for grub:
>
> /boot/grub/device.map
> (fd0)    /dev/fd0
> (hd0)    /dev/disk/by-id/ata-ST3500413AS_Z3T69GCE
> (hd1)    /dev/disk/by-id/ata-ST3500418AS_5VMJ49P1
> (hd2)    /dev/disk/by-id/ata-ST3500320AS_9QM35MY5
> (hd3)    /dev/disk/by-id/ata-ST3500820AS_9QM6V6JF
>
> To fix that my notes have "grub-install --recheck /dev/sda" from the
> last drive replacement I did. I'm guessing I need something a bit
> different to update all the drive locations? Maybe:
> "grub-install --recheck all"?
>
> But I don't need to do anything for:
> menu.lst: http://pastebin.com/7WWHajsc
> correct?
>
> What about /etc/mdadm/mdadm.conf:
> # mdadm.conf
> #
> # Please refer to mdadm.conf(5) for information about this file.
> #
>
> # by default, scan all partitions (/proc/partitions) for MD superblocks.
> # alternatively, specify devices to scan, using wildcards if desired.
> DEVICE partitions
>
> # auto-create devices with Debian standard permissions
> CREATE owner=root group=disk mode=0660 auto=yes
>
> # automatically tag new arrays as belonging to the local system
> HOMEHOST <system>
>
> # instruct the monitoring daemon where to send mail alerts
> MAILADDR tlenz@vorgon.com
>
> # definitions of existing MD arrays
> # ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=e4926be6:8d6f08e5:0ab6b006:621c4ec0
> # ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=eac96451:66efa3ab:0ab6b006:621c4ec0
> # ARRAY /dev/md2 level=raid1 num-devices=2
> UUID=934b5d12:5f83677f:0ab6b006:621c4ec0
> # ARRAY /dev/md3 level=raid1 num-devices=2
> UUID=47b3c905:5121e149:0ab6b006:621c4ec0
>
> ARRAY /dev/md0 UUID=e4926be6:8d6f08e5:0ab6b006:621c4ec0
> ARRAY /dev/md1 UUID=eac96451:66efa3ab:0ab6b006:621c4ec0
> ARRAY /dev/md2 UUID=934b5d12:5f83677f:0ab6b006:621c4ec0
> ARRAY /dev/md3 UUID=47b3c905:5121e149:0ab6b006:621c4ec0
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
