From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 7 Apr 2009 08:16:37 -0400
Message-ID: <FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> <87tz51dmmu.fsf@frosties.localdomain>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-45-953875774"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tz51dmmu.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: LinuxRaid RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-45-953875774
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 7, 2009, at 2:05 AM, Goswin von Brederlow wrote:
> Doug Ledford <dledford@redhat.com> writes:
>
>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
>> temporary mappings of incrementally added devices to device names.
>> Unfortunately, this breaks incremental assembly if used early in the
>> booting process.  Specifically, root may still be read only.  Since
>> incremental assembly is largely a udev specific feature, and udev
>> needs a writable /dev tmpfs mount even when root is still read only,
>> it's safer to put our mdadm.map file in /dev/md so that we can write
>> to the map file no matter how early in the boot process we are
>> attempting to use incremental assembly.
>
> What about /lib/init/rw?

Never heard of it.  But, if / is read-only, why wouldn't that also be  
read-only?

> You say largely udev specific so there might not be an udev running
> and no tmpfs on /dev.


Generally speaking, it's only ever going to be used by udev or run  
manually.  I doubt people will use it in things like rc.sysinit.   
However, regardless of all that, udev is started before any manual  
device bringups, so even if someone did decide to use it manually in  
rc.sysinit when root is still read only, udev will already be up by  
then.  The only exception to this would be a system that doesn't use  
udev at all, in which case they get what they get, and /dev/md/ 
mdadm.map is no better or worse than /lib/init/rw than /var/run/mdadm.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-45-953875774
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknbRCoACgkQQ9aEs6Ims9jdpACgyBYD/TskuvJ89/ZidzXQi8rw
RUEAmQE5m9lVG5+axTW7+GnRBJVOgz+V
=IXsk
-----END PGP SIGNATURE-----

--Apple-Mail-45-953875774--
