From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Tue, 7 Apr 2009 18:14:02 -0400
Message-ID: <029B34A7-B30F-4BCC-A485-530EAC76C059@redhat.com>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> <87tz51dmmu.fsf@frosties.localdomain> <FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com> <155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-57-989721329"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-57-989721329
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 7, 2009, at 5:26 PM, NeilBrown wrote:
> On Tue, April 7, 2009 10:16 pm, Doug Ledford wrote:
>> On Apr 7, 2009, at 2:05 AM, Goswin von Brederlow wrote:
>>> Doug Ledford <dledford@redhat.com> writes:
>>>
>>>> Originally, mdadm used /var/run/mdadm/mdadm.map file to store the
>>>> temporary mappings of incrementally added devices to device names.
>>>> Unfortunately, this breaks incremental assembly if used early in  
>>>> the
>>>> booting process.  Specifically, root may still be read only.  Since
>>>> incremental assembly is largely a udev specific feature, and udev
>>>> needs a writable /dev tmpfs mount even when root is still read  
>>>> only,
>>>> it's safer to put our mdadm.map file in /dev/md so that we can  
>>>> write
>>>> to the map file no matter how early in the boot process we are
>>>> attempting to use incremental assembly.
>>>
>>> What about /lib/init/rw?
>>
>> Never heard of it.  But, if / is read-only, why wouldn't that also be
>> read-only?
>
> because a tmpfs was mounted there.  It's probably a Debian-specific
> thing.
>
> Why /var/run cannot be mounted from tmpfs nice and early too I don't  
> know..
> I understand that some people think /var/run needs to persist across
> reboots to preserve ownership of directories, but they are wrong :-)
> /var/run should be a tmpfs mount point very early.

I disagree.  At least in our case, the reason that /var/run is a real  
directory is not to preserve ownerships (although it does do that as  
well), but to preserve security context for SELinux.

> I have to say that putting the map file in /dev feels very icky
> to me.  It isn't a device, and so doesn't belong in /dev.
> If we go around putting things somewhere convenient rather than
> where they belong, we quickly end up with a mess.

If that's the case, then all of udev's library data in /dev/.udev  
doesn't belong there either.  And as much as this may not be a device,  
it is in fact device specific in that it maps one device to another.   
It really is right along the lines of the data udev stores in .udev,  
so I don't see the ickyness.

> So while it might be very pragmatic, I am currently dis-inclined
> to take the patch.   Can you try asking your boot-script people
> to make /var/run be an early tmpfs ???

I'm betting that this stands 0 chance for F11 anyway, and I'm betting  
it would be a rather long, uphill fight to get them to agree to this  
period.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-57-989721329
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknb0CoACgkQQ9aEs6Ims9gG5QCgzbSXEvtZf0CwQXmalX0xZEVP
GEMAn1erzlFLzMDoqbh7wUeMxUprJJ8e
=gpMU
-----END PGP SIGNATURE-----

--Apple-Mail-57-989721329--
