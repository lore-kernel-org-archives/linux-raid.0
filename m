From: Olivier Swinkels <olivier.swinkels@gmail.com>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Tue, 7 Mar 2017 09:39:50 +0100
Message-ID: <CAJ0QwkKG8_dCzTBYEPm5CpqWMQwM=f8YBAYtatNh=9U_7ygdnA@mail.gmail.com>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
 <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org> <CAJ0QwkKAVLh7+kV_GsEL4O5hA+Pj=Y9sE_CBbWJJqDyA+gVqpA@mail.gmail.com>
 <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com> <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 6, 2017 at 8:50 PM, Phil Turmel <philip@turmel.org> wrote:
> On 03/06/2017 04:17 AM, Olivier Swinkels wrote:
>
>>> That sounds promising, as /etc was not on the array.
>>> I found a backup in /etc/lvm/backup/lvm-raid (contents shown below).
>
> Yay!  That's exactly what you need.
>
>>> Unfortunatelly when I try to use it to restore the LVM I get the
>>> following error:
>>> vgcfgrestore -f /etc/lvm/backup/lvm-raid lvm-raid
>>> Aborting vg_write: No metadata areas to write to!
>>> Restore failed.
>
> You're command doesn't specify the device name of your reconstructed
> array.
>
>>> So I guess I also need to recreate the physical volume using:
>>
>> Correction: (Put the wrong ID in the pvcreate example):
>> pvcreate --uuid "DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS" --restorefile
>> /etc/lvm/backup/lvm-raid
>>
>>> Is this correct? (I'm a bit hesitant with another 'create' command as
>>> you might understand.)
>
> I haven't actually had to do this operation but once, and I don't
> recall if the vgcfgrestore was sufficient.  But either way, you simply
> didn't tell LVM where you are restoring TO.
>
> Phil
>
Hi,
Thanks for your response, as far as I can see the syntax of the
vgcfgrestore command is correct as the destination location is in the
backup file.
After I used the pvcreate command to recreate pv the vgcfgrestore
command succeeds and the lvm is available (after activating).

However when I try to mount it I get the following error:
sudo mount -t ext4 /dev/lvm-raid/lvm0 /mnt/raid
mount: mount /dev/mapper/lvm--raid-lvm0 on /mnt/raid failed: Structure
needs cleaning

So I guess the underlying RAID array is still not ok...

Is there a way for me to validate if the degraded array contains valid
data or if there is still a disk swapped or corrupted?
Thanks.

Olivier
