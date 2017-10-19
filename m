From: NeilBrown <neilb@suse.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Fri, 20 Oct 2017 08:17:25 +1100
Message-ID: <87zi8mg7mi.fsf@notabene.neil.brown.name>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com> <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com> <59E7AE4B.5000903@youngman.org.uk> <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sfunk1x <sfunk1x@gmail.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Wed, Oct 18 2017, sfunk1x wrote:

> On 10/18/2017 12:40 PM, Wols Lists wrote:
>> What does --detail tell us about the array?
>
> https://imgur.com/a/Own0W
>
> Apologies for the imgur link, but this was the easiest way to
> communicate --detail.

Anything is better than nothing..  Can we get a photo of "mdadm
--examine" output on one of the devices (e.g. /dev/sda1) ??

Also, what mdadm version (mdadm -V) and kernel version (uname -r)?

>
>> Are you sure the three drives were added? SELinux has a habit of causing
>> havoc. Did the available space on the array increase? Did you check?
>
> Yeah. The array took about 17 hours to rebuild with the three drives
> added (I had expected over 24 as that had been my experience with adding
> the 5th drive long ago), and I had immediately started using the extra
> space. The extra 8+ TB showed up in --details, as well as df, and my
> guests could see the extra space.
>
> The SELinux audit log, however, was very clear about mdadm not being
> able to edit the conf. And it's true - the conf file did not have the
> extra drives added. I've since audited and applied a rule to allow the
> editing of the conf file, but the system is currently in permissive mode
> until the array is back online. I can disable if needed.

mdadm never tries to edit mdadm.conf.
It does modify files in /run/mdadm (or maybe /var/run/mdadm).
Can we get a photo of that audit log?

I'm very suspicious of these new drives appearing to have not metadata.
Can you
   od -x /dev/sdf | head
   od -x /dev/sdf | grep a92b
and provide a photo of the output?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnpFmYACgkQOeye3VZi
gbmsHw/+IhAy79IzOf0rbpwISlZVfCMWvMcK5FUB0B5btI/Yxd4juPSBvvurW0YZ
YJF5vXQ2sG/ZPixs+T6JzLURFvNGfAaLX/8DAg1U48OMfDKXcGG1McNYckRYMsaW
yR2NFR69zQaIvLl0OB9tuCGXGaJStIxBYN3qIJu0iLJh4u+N1Eg6dUa94gsP1m8Y
M8kLK8q2Rk4sqmgGOxR1oXrhGAQjyvVwDlhd0scQviVQQ3eB4vjSl8uACZ7hYER+
JbabaBIqnHlDZjfZ+hQB2K56v88RiHvGS/hmTOtaM9M97e+PkXU7PawF4wFSWao4
CkvD3716FUHcX4HPHUoypfX3mFlbXJXtc7+bYyoIklbCjjX7L3WKzvlUhyQUw9qR
A0dh+1dD4PQY4FGb2EFMWwsyEqy7gdYkZFo9xr6EOhSPiX8ZogkYQD9KoNvtwwI/
lxGE8V699OK4bJwWyr21Wa+r5q/eLJ07oBK5re67KcaaMTkyhWjqpllgfkU6X6d8
8V6md0icXPbZHGHdkLHQhFsqOK9hsfrZEk0m/vQPZeOstXSous1VYuUnZfrHX2YQ
kFd+H/yOyLJdSX+6tWl11dbEieeLdhcC0cgADN3o14aSC1+/ata0SImQP3mPsPR8
2nHCiQMM4aAlIWek/7BpXR1AKnL16pCN+cjLavvPEQ0pQnyYN7Y=
=I+8v
-----END PGP SIGNATURE-----
--=-=-=--
