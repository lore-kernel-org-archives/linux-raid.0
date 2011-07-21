From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: Raid5 boot failure after grow
Date: Thu, 21 Jul 2011 13:06:36 +0300
Message-ID: <4E27FA2C.9070207@oldum.net>
References: <CADVynFA9NffR7jMrN5HV05n9V0=SOVdyFQjvCvNP=MU+G-ur6g@mail.gmail.com> <4E260E21.5020001@turmel.org> <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADVynFDJO3_87ub-qfKK-0JWOB0nYK5P7=Au7fhcd+LEQkP=OA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: shaun.reich@kdemail.net
Cc: Shaun Reich <predator106@gmail.com>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
did you actually chroot into the grown array before updating your initramfs image?

BTW what is on the raid5? Is it the / fs?

Cheers,
- -N

On 07/20/2011 07:39 PM, Shaun Reich wrote:
> Do you happen to know how to rebuild it when I can't boot into it?
> I've tried booting into a livecd, mounting the raid volume and the
> /boot, running 'dracut --mdadmconf "initramfs-$(uname -r).img" $(uname
> -r)', copying the generated initramfs into the separate /boot
> partition, and making grub try to boot it, but it simply is not
> working.
> 
> It seems to be because it's actually using the livecd's kernel and
> mods, which is rather unfortunate and would probably be why it is
> unable to boot. I've also tried simply doing it from the livecd (with
> the proper mdadm.conf) and then copying that file (from the livecd),
> into /boot. That at least gets me from a blank blinking cursor, to a
> message about a failed modprobe attempt for /lib/modules, prior to
> falling back to a shell.
> 
> Ideas?
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOJ/osAAoJEDFLYVOGGjgXkJQH/2HSfCiRMpTqCy4EPzKEudoi
Wa06t862E0HXJuTauHFmtRAYvFV82G7TaRxSPznSDrKsit7FTMPSdzSWGUf9JDHO
miFSPaENdB/H6qV1FA1yYX3KcARaihAlqbDX2OcMFaLFr5krRpy8FZ8gBL453JYw
SlYl2/UP3q8r+TuobCuy8bwWV3Xv8Iw6UO0SiYZYZAELaASRcnNnnFw+wb21VZI7
HKItkpO6mk/UkQjgbGykSOQjLLBSFUx9MLU1FI+nOwDnlzyyb5/Jnv3zUjWhOC7K
lBIz3Sq7E2Jp6XKqZ9kKtTxebRxMybeEsUWJ3GTwQ5HrUryywZ4uGuntP9lWcJY=
=nxFq
-----END PGP SIGNATURE-----
