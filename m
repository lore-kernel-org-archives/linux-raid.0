From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Mon, 04 May 2009 19:02:02 +0200
Message-ID: <873abkn6np.fsf@frosties.localdomain>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<e9c3a7c20904281526i59983678mb6fbc10e1761d9f1@mail.gmail.com>
	<87ljpgleku.fsf@frosties.localdomain>
	<e9c3a7c20905011424s6c3b3fd6ya563539b3c079d4@mail.gmail.com>
	<87r5z8jvxe.fsf@frosties.localdomain>
	<49FC376C.6050508@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49FC376C.6050508@anonymous.org.uk> (John Robinson's message of
	"Sat, 02 May 2009 13:07:08 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Robinson <john.robinson@anonymous.org.uk> writes:

> On 01/05/2009 23:33, Goswin von Brederlow wrote:
>> Dan Williams <dan.j.williams@intel.com> writes:
>>
>>> On Fri, May 1, 2009 at 2:04 PM, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>>>> And is horribly ugly when you have to switch hardware. And try doing
>>>> it with disks from different controlers? What bios supports that?
>>> This is just a simple trade-off between two options.
>>>
>>> 1/ If you want to reliably boot from multiple disks then make a native
>>> md-raid1 array for /boot like hpa suggests.
>>
>> Which still has the same problems as the raid5. How to handle the
>> bootloader. Say I have a raid1 over sda/b with lvm on it. How do I
>> boot that? How do I get the bootloader cloned to a new spare disk when
>> it gets added?
>
> `dd if=/dev/originaldrive of=/dev/newdrive bs=512 count=1` to clone
> the boot sector from one of the remaining original drives; this clones
> your partition table too. Once that's done, and you've added the new
> drive's partition(s) back into the RAID set(s) and it's synced, it
> will boot.

Except that the bootblock then loads the next stage of the bootloader
which you did not copy. And the partition table might not work on that
disk at all if size and/or geometry differ.

> Or just tell your bootloader to install itself on the new drive.
>
>> It realy makes no difference if it is a raid0/1/10/4/5/6.
>
> Yes it does - anything which needs access to more discs than whatever
> the BIOS offers as the boot drive via int13 is asking for trouble.

Which is totally irelevant as THAT problem exists with partitions and
existing bootloader just as well as with the proposed
improvement. Nothing can change that short of fixing your hardware
architecture. .oO(go open bios)

>>> 2/ If you do not want to make /boot into an md-raid1, and you still
>>> want to boot from raid5, then use $VENDOR's raid5 option-rom and
>>> mdadm's external metadata support.
>>
>> There is no such thing as $VENDOR's raid5 option-rom in pretty much
>> all cases. And even raid0/1 roms are horribly.
>
> Dan was being modest referring to $VENDOR; any recent board with an
> Intel ICHxR has Intel Matrix RAID with RAID-5 in the BIOS/option
> ROM. I imagine other chipsets have RAID-5 too. I would have used this
> method on my Asus P5Q Pro but the CentOS 5 installer doesn't support
> it; I think recent Fedora and Ubuntu installers do, thanks to
> excellent work by Dan, Neil Brown and others improving md's support
> for 3rd-party metadata formats.
>
> Cheers,
>
> John.

I still don't have a single system that can.

MfG
        Goswin
