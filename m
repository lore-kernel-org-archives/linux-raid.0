From: "Jay Strauss" <me@heyjay.com>
Subject: Re: re mdadm  raid1 creation problems
Date: Sat, 12 Jun 2004 07:58:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006401c4507c$f7e62b40$6705a8c0@a30>
References: <40CAD765.7040307@prairie.lakes.com>
Reply-To: "Jay Strauss" <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: rrk <rrk@prairie.lakes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rrk,

You say make filesystem on hda, do you really mean you created
filesystems hda[123]?

After you edited /etc/boot/grub/menu.lst did you run grub?

You don't need to reboot so often

take a look at:
http://marc.theaimsgroup.com/?l=linux-raid&m=108571782912454&w=2

Jay
----- Original Message ----- 
From: "rrk" <rrk@prairie.lakes.com>
To: <linux-raid@vger.kernel.org>
Sent: Saturday, June 12, 2004 5:13 AM
Subject: re mdadm raid1 creation problems


> sorry my reply's are not making it to the list
>
> the error msg i get is
>
> /dev/md1 file system size ( according to the superblock) is 2560351
> the pyhical size of the device is 2560320 either the superblock or
> the partion table is corrupt
>
> /dev/md1: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY
>
> i get this msg on the first boot with md1 as the primary boot partion
>
> i thought i was being pretty careful about rebooting after all partion
> changes
>
> the build order/process is
>
> build and test hda  debian 2.4.26 with raid compiled in
> sfdisk to transfer partions   sfdisk -d /dev/hda | sfdisk /dev/hdc
> set hdc partion type  to fd
> reboot
> mk file system on hdc and copy hda to hdc
> reboot
> test hdc as primary boot
> reboot
> create md1   mdadm --create /dev/md1 --level=1 --raid-devices=2 missing
> /dev/hdc1
> there are 3 md devices / home & var
> reboot
> mount md device for test
> change hda partion type to fd
> reboot
> edit fstab and grub on md devices
> shutdown
> boot from mepis rescue disk
> mdadm --add /dev/md1 /dev/hda1
> wait for resync
> shutdown
> reboot from md1
>
> thanks
> rob
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

