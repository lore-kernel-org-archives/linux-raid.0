From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Tue, 15 Jan 2013 09:57:22 -0500
Message-ID: <50F56E52.1090302@ubuntu.com>
References: <20121109144636.2215.91684.stgit@localhost.localdomain> <50EF3961.5050306@ubuntu.com> <8565BDA60DEA9E4C91B1047AD1958FBE1DEC8F5B@IRSMSX104.ger.corp.intel.com> <50F419F2.9050809@ubuntu.com> <679865E03F4C71419D9847EA3AACB16316215258@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB16316215258@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Cc: "Tomczak, Marcin" <marcin.tomczak@intel.com>, "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/15/2013 5:31 AM, Patelczyk, Maciej wrote:
> Hi Phillip,
> 
> Mdadm does not care about the controller unless you created IMSM 
> based RAID. Basically you can create that type of RAID *only* on 
> Intel based platforms with OROM enabled. It's Intel solution, we 
> support it and we maintain it. It's very specific type of metadata.
> We provide this functionality in Linux, Windows and OROM/uEFI. It
> must be compatible between all three environments. If you have dual
> boot machine you can safely boot into Windows and then into Linux
> and your RAID Volume will be in proper state.

> Dmraid cannot boot from RAID Volume, OROM can boot from IMSM RAID 
> Volume directly. You don't need separate partition, hard drive or 
> anything else. If you run Intel platform you can boot directly
> from supported RAID Volume. This is because OROM supports it.
> Mdadm respects OROM restrictions when creating IMSM based RAIDs.

I understand that you will not be able to boot directly from the array
without the OROM, but sometimes you just need to access your data any
way you can, and mdadm should not refuse to mount the array based on
the absence of the OROM.  Think disaster recovery.  You should always
be able to connect the disks to another machine that may not have an
Intel controller and rescue your data.

Additionally the ability to create and use arrays without the OROM
allows for simulation and testing, which is something the mdadm test
suite should be doing.

> Spanning in Linux is something obvious. I know that is simply
> works because of Linux architecture. However spanned RAID Volumes
> are not supported in OROM and in Windows. If you allowed for
> spanned RAID Volumes in Linux we open the Pandora's box. In the
> worst case you will lose you data when entering to OROM (OROM will
> see only one set of disks attached to one controller and can mark
> RAID Volume as Failed) or if you boot to Windows (Windows driver
> will see two failed RAID Volumes in the worst case). In other case
> you will have RAID Volume marked as Degraded and rebuild will
> start. And what if you create 'bootable' RAID Volume? Well you may
> not be able to boot from it when it's spanned.

Warnings about potentially troublesome situations are good, but
outright refusal is not.  Yes, I realize it would be a problem for
Windows due to the poor way the driver has to be implemented ( why
can't the OROM see other disks on other controllers? ), but sometimes
you don't care about that.  For instance, if you are setting up the
array on one machine where you can not connect all of the drives to
the same controller ( and do not care about booting from the array on
this machine ), but you are planning on moving them to a machine where
they will be.  This is just one example of many situations where you
need to be able to say "I know what I'm doing, go ahead anyway".

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJQ9W5SAAoJEJrBOlT6nu75mZIH/iusNcvgb+Gu2CWmjeSjfcNA
b66NMNdN63csAew9chaya71MxbET9RE1+SQyTXQZkz6tbtbrxP/H2gu0JzNLjO3T
G2PsXo1edHD9YTkx7wUImJgCANglqWmvbDwDtR5EFuyoEytzFp7PJCzcbPJM8DRU
c60j8OWOmxtbkCnYyQmmOPJD3zB9t9UdFnYdzr+ACnj9+3j0Z950gehw7TaOEKMh
1jTwR9SftdH979GHL2EsLQciyFLPfcT8/Xev1UnYWyj8DSmFs591fNI1zI+t/EsY
anBTJeoD0hkbqe67TaqZSnpX5acEqP1xHmCeAfECfmkreH7JTPwjMQOv457+Na8=
=eKzx
-----END PGP SIGNATURE-----
