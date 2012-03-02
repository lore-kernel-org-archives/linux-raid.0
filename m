From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Fri, 02 Mar 2012 09:44:20 +0100
Message-ID: <4F508864.4050600@profihost.ag>
References: <4F4C9A11.9060302@profihost.ag> <4F4F4B1D.4050000@redhat.com> <4F4F4EB3.6030909@profihost.ag> <4F4F519E.7040206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F4F519E.7040206@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Looking at your original mail again - you are running a raid with
> metadata 1.2, which means your BIOS will not know how to read the disks
> as a raid device.
> You should be able to install grub into the MBR of /dev/sda or /dev/sdb.
> I believe that is possible with 1.2 metadata. 1.1 was totally broken for
> this if I remember correctly.

Correct that's why i've also tried to install it on sda / sdb but then
grub complains about not finding any partition table.

> That said, if your system is EFI based, I suspect you will need to have
> the bios_grub partition on the physical drives so the BIOS can read it.
> It's not going to do much good having it on the raid partition if the
> BIOS isn't able to read those.
The bios is not the problem - grub simply does not want to install it
boot sector to sda / sdb.

It does it fine when using metadata 0.9.

Stefan
