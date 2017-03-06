From: Phil Turmel <philip@turmel.org>
Subject: Re: [RAID recovery] Unable to recover RAID5 array after disk failure
Date: Mon, 6 Mar 2017 14:50:52 -0500
Message-ID: <c3ae0e4d-dccc-9cb4-72b0-28a1bde3c752@turmel.org>
References: <CAJ0QwkJqRbJtM9HiXL+cCj2TkQQRahGgWTwD9QKH_CBfbJeLKA@mail.gmail.com>
 <0a6e4a82-665c-6e62-293f-151e41c67842@turmel.org>
 <CAJ0QwkKAVLh7+kV_GsEL4O5hA+Pj=Y9sE_CBbWJJqDyA+gVqpA@mail.gmail.com>
 <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ0QwkKuSKzE7_4h1aUA4XMyNAAdmFR4J6z+Z_vW5nsW3OcZtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Olivier Swinkels <olivier.swinkels@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/06/2017 04:17 AM, Olivier Swinkels wrote:

>> That sounds promising, as /etc was not on the array.
>> I found a backup in /etc/lvm/backup/lvm-raid (contents shown below).

Yay!  That's exactly what you need.

>> Unfortunatelly when I try to use it to restore the LVM I get the
>> following error:
>> vgcfgrestore -f /etc/lvm/backup/lvm-raid lvm-raid
>> Aborting vg_write: No metadata areas to write to!
>> Restore failed.

You're command doesn't specify the device name of your reconstructed
array.

>> So I guess I also need to recreate the physical volume using:
> 
> Correction: (Put the wrong ID in the pvcreate example):
> pvcreate --uuid "DWv51O-lg9s-Dl4w-EBp9-QeIF-Vv60-8wt2uS" --restorefile
> /etc/lvm/backup/lvm-raid
> 
>> Is this correct? (I'm a bit hesitant with another 'create' command as
>> you might understand.)

I haven't actually had to do this operation but once, and I don't
recall if the vgcfgrestore was sufficient.  But either way, you simply
didn't tell LVM where you are restoring TO.

Phil

