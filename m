From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Upgrading to GRUB2 from GRUB Legacy on RAID1
Date: Wed, 16 Jun 2010 15:41:54 -0700
Message-ID: <AANLkTinYXblLrapwCWtWhlqa9H0hbCV7PUaOjNLONZUj@mail.gmail.com>
References: <4D.41.26996.506811C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D.41.26996.506811C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 10, 2010 at 5:40 PM,  <lrhorer@satx.rr.com> wrote:
>
> =A0 =A0 =A0 =A0I thought I had sent this previously, but I don't see =
a reflection
> copy in my in-box. =A0Pardon me if this is a duplicate, but OTOH, if =
it is,
> doesn't anyone have any comments or advice? =A0I'm especially a littl=
e fuzzy
> around step 4 below. =A0I think I need to run `grub-setup` or somethi=
ng, but
> I'm not clear on the details.
>
> =A0 =A0 =A0 =A0Dilemma: GRUB legacy will not upgrade to GRUB2 on my m=
achines. =A0The
> systems were originally built to "fake out" GRUB legacy by using a 1.=
0
> superblock on a pair of RAID1 members and pointing GRUB to one or the=
 other
> of the disks so it can chain load from what it thinks is an ordinary =
primary
> partition. =A0Once initrd loads and md is active, it assembles the ar=
rays and
> then the kernel mounts / and then /boot, and booting continues normal=
ly.
>
> =A0 =A0 =A0 =A0The cause: When dpkg instructs grub-pc to configure it=
self, it fails
> because it is unable to reconcile the information in /boot/grub/menu.=
lst
> with the hardware mounted by /etc/fstab.
>
> =A0 =A0 =A0 =A0The cure? : I was thinking I should be able to comment=
 out the
> entries for /dev/md1 in /etc/fstab =A0and /etc/mdadm/mdadm.conf, and =
reboot
> the system. =A0Then I think I can
>
> 1. =A0Mount /dev/hda1 to /boot.
>
> 2. =A0Upgrade GRUB, which should now understand both /etc/fstab and
> /boot/grub/menu/lst.
>
> 3. =A0Reboot to make sure it works.
>
> 4. =A0Edit /boot/grub/grub.cfg and /boot/grub/device.map to let GRUB2=
 know it
> should be booting from an array and to make sure it is loading the RA=
ID1
> module.
>
> 5. =A0Umount /boot and create a new 1.0 superblock RAID1 array using =
only
> /dev/hda1 and a missing member. =A0Mount the new array as /boot.
>
> 6. =A0Add the new array info into /etc/mdadm/mdadm.conf and change /e=
tc/fstab
> back to mount /dev/md1.
>
> 7. =A0Run update-initramfs to copy the new configuration into initrd.
>
> 8. =A0Reboot and make sure GRUB2 can now boot into the new array.
>
> 9. =A0Add /dev/hdb1 into the new array, and re-sync the array.
>
> 10. Update /etc/mdadm/mdadm.conf with the full array info, getting ri=
d of
> the missing member, and remove the reference to the old array altoget=
her.
>
> 11. Run the GRUB update routine to remove the chain-load from GRUB le=
gacy.
>
> 12. Run update-initramfs to copy the final configuration into the ini=
trd (if
> GRUB update doesn't already do it.)
>
> =A0 =A0 =A0 =A0Is my thinking correct, here? =A0Have I missed a step?=
 =A0Up until step
> 9, I should be able to easily revert back to my original configuratio=
n by
> simply removing the comment for the old array, forcing an assembly of=
 the
> old array using only /dev/hdb1, add back /dev/hda1, resync the array,=
 remove
> the comment from /etc/fstab and run update-initramfs.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

IIRC Grub 1.97 ('2') supports the 0.90 metablock format but not the
1.0 metablock format.  You might just backup the contents of /boot and
make that small pair of partitions use the older format (re-create
that array).  For /boot 0.90 should be sufficient in most cases.

However, I've not tested grub 2 with mdadm. Only my ubuntu laptop uses
grub2; both gentoo and arch (as of the last time I looked) were still
using grub legacy.

In fact, if grub supports the older metablock format but not the newer
maybe you should file/attach to a bug about it.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
