From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Patch for boot-time assembly of v1.x-metadata-based soft (MD) arrays: reasoning and future plans
Date: Sun, 26 Aug 2007 17:32:46 -0700
Message-ID: <e9c3a7c20708261732o2b962531obbf9ab370f195be8@mail.gmail.com>
References: <778663.11466.qm@web33606.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <778663.11466.qm@web33606.mail.mud.yahoo.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Abe Skolnik <abe_skolnik@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/26/07, Abe Skolnik <abe_skolnik@yahoo.com> wrote:
> Dear Mr./Dr. Williams,
>
Just "Dan" is fine :-)

> > Because you can rely on the configuration file to be certain about
> > which disks to pull in and which to ignore.  Without the config file
> > the auto-detect routine may not always do the right thing because it
> > will need to make assumptions.
>
> But kernel parameters can provide the same data, no?  After all, it is
> not the "file nature" of the "config file" that we are after,
> but rather the configuration data itself.  My now-working setup uses a
> line in my "grub.conf" (AKA "menu.lst") file in my boot partition that
> says something like...
>   "root=/dev/md0 md=0,v1,/dev/sda1,/dev/sdb1,/dev/sdc1".
> This works just fine, and will not go bad unless a drive fails or I
> rearrange the SCSI bus.  Even in a case like that, the worst that will
> happen (AFAIK) is that my root-RAID will not come up and I will have to
> boot the PC from e.g. Knoppix in order to fix the problem
> (that, and maybe also replace a broken drive or re-plug a loose power
> connector or whatever).  Another MD should not be corrupted, since they
> are (supposedly) protected from that by supposedly-unique array UUIDs.
>
Yes, you can get a similar effect of the config file by adding
parameters to the kernel command line.  My only point is that if the
initramfs update tools were as simple as:
mkinitrd "root=/dev/md0 md=0,v1,/dev/sda1,/dev/sdb1,/dev/sdc1"
...then using an initramfs becomes the same amount of work as editing
/etc/grub.conf.

> > So I turn the question around, why go through the exercise of trying
> > to improve an auto-detect routine which can never be perfect when the
> > explicit configuration can be specified by a config file?
>
> I will turn your turning of my question back around at you; I hope it's
> not rude to do so.  Why make root-RAID (based on MD, not hardware RAID)
> require an initrd/initramfs, especially since (a) that's another system
> component to manage, (b) that's another thing that can go wrong,
> (c) many systems (the new one I just finished building included) do not
> need an initrd/initramfs for any other reason, so why "trigger" the
> need just out of laziness of maintaining some boot code?  Especially
> since a patch has already been written and tested as working. ;-)
>
Understood.  It comes down to a question of how much mdadm
functionality should be duplicated in the kernel?  With an initramfs
you get the full functionality and only one codebase to maintain
(mdadm).

[snip]

> Sincerely,
>
> Abe
>

Regards,
Dan
