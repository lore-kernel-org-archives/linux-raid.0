From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: What will happen with spares in this scenario?
Date: Tue, 30 Jun 2009 19:54:58 +0200
Message-ID: <87d48l8v4d.fsf@frosties.localdomain>
References: <ab50889f0906290828s44e10b14n1af6d23556e3f0ee@mail.gmail.com>
	<87zlbruinb.fsf@frosties.localdomain>
	<BD450977-FA0D-4F63-8ADB-1314FA43E654@googlemail.com>
	<87r5x2xs7i.fsf@frosties.localdomain>
	<ab50889f0906300116p42b48afnf1605ea1e8cdf60c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab50889f0906300116p42b48afnf1605ea1e8cdf60c@mail.gmail.com>
	(John McNulty's message of "Tue, 30 Jun 2009 09:16:09 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John McNulty <johnmcn1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John McNulty <johnmcn1@googlemail.com> writes:

> On Tue, Jun 30, 2009 at 5:26 AM, Goswin von Brederlow<goswin-v-b@web.de> wrote:
>>
>> Hmm, do I understand this right that you want 2 partitions. One for
>> /boot and one for everything else on lvm?
>>
>> Just a crazy idea. But why not put /boot on lvm too and use grub2 or
>> lilo as bootloader? Or does Kickstart not allow that?
>
> I didn't think that booting from an LVM device was supported, whether
> it's sitting on an md raid device or not.  How is the bootloader meant
> to find the kernel and initrd without first constructing the VG and
> mounting the /boot Logical Volume.  It's been quite a while since I
> looked (we get into the habit of doing things the same way) but last
> time I checked this didn't work.
>
> Rgds,
>
> John

In case of grub2: It does support both raid and lvm. The raid
superblocks are parsed to construct mdX devices and the lvm metadata
is parsed to locate lvm logical volumes. So you could say it does
construct the LV and mounts the FS.

In case of lilo: Lilo only stores a list of blocks where the
kernel/initrd are on the device. Afaik each component device of a raid
stores the the block numbers for the kernel/initrd on that component
device. So no matter which component device boots it will find the
kernel/initrd on the same device. The raid1 and lvm are completly
circumvented.

MfG
        Goswin
