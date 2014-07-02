From: "John Stoffel" <john@stoffel.org>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 12:43:17 -0400
Message-ID: <21428.13989.101969.396667@quad.stoffel.home>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
	<20140702204502.6b538fa8@notabene.brown>
	<20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Pedro" =3D=3D Pedro Teixeira <finas@aeiou.pt> writes:

Pedro> cpu is a phenom x6, 8gb ram. controller is LSI 9201-i16. hdd's a=
re =20
Pedro> seagate sshd ST1000DX001.

Pedro> So I run the "dd if=3D/dev/md0 of=3D/dev/null=A0 bs=3D4096" and =
it failed on =20
Pedro> alot of places. I had to restart the command several times with =
the =20
Pedro> skip parameter set to a couple of blocks after the last block er=
ror. =20
Pedro> It run for about 1.5TB of the total 13TB of the volume.
Pedro> The md volume didn't drop any drive when running this.

Can you destroy the filesystem and re-create the RAID6 from scratch by
any chance?  Or can you maybe create a smaller array with only 6
devices to run some tests? =20

Can you provide more details on your ext4 filesystem using tune2fs?
Have you tried using XFS instead?  Does the filesystem have a logfile
or not?  And does a full fsck run to completion? =20

Have you checked all the cables?  Do you have RAID firmware on the LSI
card by any chance, or are they setup as JBOD?  Could you have a too
small a power supply so you're seeing corruption on the system due to
low voltage on one of the 5V or 12V rails?  Can you try powering half
the disks from another power supply as a test? =20

Do you have a graphics card in the system?  If so, can you pull it and
run it headless, or maybe put in a less power hungry card? =20

John
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
