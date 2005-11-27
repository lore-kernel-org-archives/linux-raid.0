From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: mdadm HOWTO
Date: Sun, 27 Nov 2005 10:28:37 +0100
Message-ID: <43897C45.9040404@xss.co.at>
References: <20051127060934.53663.qmail@web51403.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051127060934.53663.qmail@web51403.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Smith <easygreenus@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Mike Smith schrieb:
> Hi,
> 
> I've been using mdadm for over a year now and really
> like the utility.
> 
> Can someone point me to a howto type document that
> shows how
> to do various tasks.  Like recovering a metadevice.  I
> suspect my situation is not unique and would probably
> be
> covered.
> 
> I have a mother board with 3 sata raid controllers.
> I have two drives on the first that I use for the OS 
> and a mirror of the OS using mirrordir.
> 
> I have two 250GB drives on the second sata controller
> and
> two on the third.  I have put these four drives in a
> RAID5 metadevice ( /dev/md0 ) using mdadm.  I then use
> LVM to slice/dice md0 into the various filesystems I
> need.
> 
> I've run this way for over a year and now want to
> upgrade my
> OS.  I have been running Mandrake 10.1, and want to
> move to
> Mandrivia 2006.
> 
> My first problem is that my devices are renumbered
> with the
> new OS install.
> 
>                     Mandrake        Mandrivia
> 1st Controller        sda             sda
>                       sdc             sdb
> 
> 2nd Controller        sdb             sdc
>                       sdd             sdd
> 
> 3rd Controller        sde             sde
>                       sdf             sdf
> 
This is the reason I always use the uuid to assemble
RAID devices in my initial ramdisk init script.

In my initial ramdisk init script I have the following
line:

mdadm -v --assemble --scan --config=/mdadm.conf --run

Before creating the initial ramdisk image (usually during
the system installation process) I create the file mdadm.conf
with the following commands:

# echo "DEVICE partitions" > mdadm.conf
# mdadm --examine --brief --scan --config=partitions >> mdadm.conf

and put this file also in the initial ramdisk image.
That way I don't have to worry about device file names
as mdadm looks for the right uuid on all partitions it
finds. This is a great feature of mdadm!

> Originally,  I created the RAID5 device using sdb,
> sdd, sde, and sdf.
> Under Mandrivia,  I was successful in using mdadm to
> assemble a
> RAID5 device, but trying to mount the filesystems (
> /dev/vg1/video )
> it said they did not exist.
> 
So, you can assemble and start your array under Madrivia.

But it looks as your volume group is still not activated.
This has nothing to do with mdadm. You have to use your
LVM commands to do that.

Try the following:

# vgscan
# vgchange -a y

This will activate all volume groups defined with all
devices active on your system.

I don't know Mandrake or Mandriva so you'll have to check
how you can put this commands in your boot process.

To check which volume groups are activated, you can use
the following command:

# vgdisplay

To check which logical volumes are online, run the following:

# lvscan


HTH

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDiXxDxJmyeGcXPhERAovNAJ95U/aWkHnhZ4QTFfEM1ihm5jdEmwCeKrgp
jZSnEcZUFqVFjZtCAjkY1+Y=
=/QYw
-----END PGP SIGNATURE-----
