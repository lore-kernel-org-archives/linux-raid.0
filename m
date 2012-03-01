From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Thu, 01 Mar 2012 11:38:22 +0100
Message-ID: <4F4F519E.7040206@redhat.com>
References: <4F4C9A11.9060302@profihost.ag> <4F4F4B1D.4050000@redhat.com> <4F4F4EB3.6030909@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4F4EB3.6030909@profihost.ag>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/01/12 11:25, Stefan Priebe - Profihost AG wrote:
>> > I am not sure whether this is the reason, but you have disks with gpt
>> > partition tables, while it looks like you are still using grub1? I
>> > didn't think grub1 was able to handle gpt.
> ~# grub-setup -V
> grub-setup (GRUB) 1.99-14

Not grub1 then .....

Looking at your original mail again - you are running a raid with
metadata 1.2, which means your BIOS will not know how to read the disks
as a raid device.

You should be able to install grub into the MBR of /dev/sda or /dev/sdb.
I believe that is possible with 1.2 metadata. 1.1 was totally broken for
this if I remember correctly.

That said, if your system is EFI based, I suspect you will need to have
the bios_grub partition on the physical drives so the BIOS can read it.
It's not going to do much good having it on the raid partition if the
BIOS isn't able to read those.

BIOS and partition tables isn't exactly my area of expertise, so I could
be wrong on some of this.

Cheers,
Jes
