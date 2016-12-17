From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: root in grub for raid1
Date: Sat, 17 Dec 2016 21:11:07 +0000
Message-ID: <5855A9EB.2080608@youngman.org.uk>
References: <20161216221414.7c67f80b@para.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161216221414.7c67f80b@para.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Egbert Bouwman <eppo@xs4all.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/12/16 21:14, Egbert Bouwman wrote:
> Newbie, but this list seems to be for developers.
> If that is true I'll ask my one question, and then retire.
> 
> Actually it is a question about grub, but I think the raid specialists
> know more about this grub problem than the grubbers do.
> 
> Setting up raid1 for /dev/sda and /dev/sdb (actually for missing and /dev/sdb)
> on /dev/md/data succeeded, but now I have to do a dpkg-reconfigure
> grub-efi-amd64 and i don't know how to specify root in the two grub lines: 
> 	set root=...
> and the linux command line
> 	linux root=
> Please note that i chose md/data, and not the common md0.
> 
> egbert
> 
The first thing I noticed in your post was "grub-efi-amd" - I thought on
modern UEFI systems, you used UEFI and not grub to boot linux ...

But, as another datapoint, I boot from almost exactly the same setup as
you, two mirrored disks on a GPT/BIOS system. My grub entry is

menuentry 'Gentoo GNU/Linux, with Linux 4.4.6-gentoo' --class gentoo
--class gnu-linux --class gnu --class os $menuentry_id_option
'gnulinux-4.4.6-gentoo-advanced-ab538350-d249-413b-86ef-4bd5280600b8' {
        load_video
        insmod gzio
        insmod part_gpt
        insmod part_gpt
        insmod diskfilter
        insmod mdraid1x
        insmod ext2
        set root='mduuid/69270eaca840f6e70199064bd5863c5d'
        if [ x$feature_platform_search_hint = xy ]; then
          search --no-floppy --fs-uuid --set=root
--hint='mduuid/69270eaca840f6e70199064bd5863c5d'
ab538350-d249-413b-86ef-4bd5280600b8
        else
          search --no-floppy --fs-uuid --set=root
ab538350-d249-413b-86ef-4bd5280600b8
        fi
        echo    'Loading Linux 4.4.6-gentoo ...'
        linux   /boot/vmlinuz-4.4.6-gentoo
root=UUID=ab538350-d249-413b-86ef-4bd5280600b8 ro  domdadm
        echo    'Loading initial ramdisk ...'
        initrd  /boot/initramfs-genkernel-x86_64-4.4.6-gentoo
}

Cheers,
Wol
