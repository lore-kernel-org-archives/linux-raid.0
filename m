From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: moving arrays from MBR part table install to GPT? Possible?
Date: Sun, 16 Aug 2015 13:27:47 +0100
Message-ID: <55D081C3.4090604@youngman.org.uk>
References: <55D02E2E.1080909@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55D02E2E.1080909@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/08/15 07:31, David C. Rankin wrote:
> All,
> 
>   I suffered a controller failure on my server housing a
> 2-disk/4-partition raid1 mdraid array under Archlinux with MBR partition
> table. The original motherboard was non-UEFI, of course everything now
> is. I am getting conflicting information whether my existing arrays are
> usable with the new UEFI board. I don't know if this is the best place
> to ask, but heck, there is a lot of collective wisdom regarding mdadm here.

I run gentoo ... and migrated my system from mbr to gpt ...
> 
>   I am planning to set the BIOS on the new board to Legacy and attempt
> to use my existing arrays by booting the Arch install media, assembling
> the arrays, then chrooting and rebuilding initramfs to preserve the
> existing setup. Is there any reason that can't work?. (I haven't dealt
> with the UEFI fun before)

If your Arch will work on the new hardware, I suspect, actually, that
just transferring the drives across and booting will work (although I
haven't played with UEFI before either).

Your biggest problem is going to be Grub2, I expect.
> 
>   If that will not work, I'm left with installing to new drives. If I do
> end up with a full install, I'm left with the MBR or GPT partition table
> choice. I will install to 2 new drives that I want to again be setup as
> raid1 arrays with mdadmin. Does mdadmin/mdraid require a MBR partition
> type? Or, can I create a GPT partition table and use mdadm to manage the
> array?

Drives over ?2TB require GPT. It's nothing to do with the software - the
mbr (allegedly) cannot partition larger drives. gfdisk will quite
happily write both a GPT and an MBR to the disk, for the software to use
either. It does warn you, however that "mixing and matching" is
dangerous if they get out of sync.
> 
>   If GPT is fine, then is there anyway to migrate my existing array to a
> GPT partition table in the new box without having to install to new
> drives with a GPT table and then mount one of the existing drives to
> copy the data to the new array?

Use gfdisk, tell it to write a GPT. Just be careful it doesn't mess up
Grub2 for you ...

If you want to use new drives, once the system is up and running just
use mdadm --add or --replace.
> 
>   If these questions are already answered in a link somewhere, I
> apologize, I haven't found it. Thanks for any help/advise you can provide.
> 
Personally, I think your biggest problem is going to be grub. What I'd
do (and I'm going to have to do it sometime soon) is ...

Put the old drives on the new mobo. Boot using recovery media and make
sure the arrays are okay (shouldn't be a problem).

READ UP ON GRUB! Did I say that was going to be your biggest problem?

Fix grub to boot into your old Arch setup. It might be a good idea to
fit a new (old :-) disk solely for installing grub on until you're happy
everything is okay.

Your old system will now be up and running on the new mobo. Don't bother
switching your old drives to gpt, although you can, as I say, just use
gfdisk to write a GPT. Just be careful it doesn't mess up grub though ...

If you want to add new drives, you can use GPT on them, as I say, if
they're large disks, you'll need to use GPT.

Sounds like it's a small system, a home system? If you get new drives,
make sure they're proper raid drives, like WD Red. I've got Seagate
Barracudas, which was a mistake ...

Cheers,
Wol
