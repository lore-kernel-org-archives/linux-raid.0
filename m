From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: mdadm+lvm2: ioctl error and cannot mount the device nodes?
Date: Thu, 02 Jul 2009 23:55:36 +0200
Message-ID: <4A4D2CD8.8060705@gmx.net>
References: <4A4D1478.7010501@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A4D1478.7010501@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think the mdadm was uncleanly shut down

the rootfs was on nfs and the nfs server halted and was taken off.

mdadm thinks the array is clean, how to i check if its unclean without 
risking my data

could this unclean shutdown result in device mapper errors like this?

best regards
Michael Ole Olsen

Michael Ole Olsen wrote:
> i keep getting
>
> [1]
> device-mapper: table: device 9:0 too small for target
> device-mapper: table: 254:11: linear: dm-linear: Device lookup failed
> device-mapper: ioctl: error adding target to table
>
> with a cleanly installed system (debian lenny netinstall)
>
> my raid is a raid5 reshaped to raid6 with 2.6.30 by echoing into /sys
> (all Q blocks on the last disk)
>
> i can see all device nodes in /dev/mapper but just not mount them
>
> if i try to mount it just says:
>    mount: you must specify the filesystem type
> and the dmesg output as in [1]
>
> these are the modules in my initramfs:
>
> xfs
> ext3
> dm-mod
> md
> raid0
> raid1
> raid10
> raid456
> raid6_pq
> linear
>
> # usb-storage deps
> usbcore
> usbhid
> libata
> scsi_transport_spi
> usb-storage
> scsi_mod
> sg
> sd_mod
> sbp2
>
>
> Any idea what I am doing wrong? I thought the problem [1] would
> be because of a misconfigured kernel with no
> devicemapper support, but I think have compiled everything in?
>
> I cannot use any other kernels than 2.6.30 or it will not assemble
> the raid6 (mdadm) so I dont think i have another option than
> compiling it myself, apt has only 2.6.22 or such
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
