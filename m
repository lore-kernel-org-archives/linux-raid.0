From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm: move mdadm.map file into /dev/md
Date: Thu, 9 Apr 2009 15:28:53 -0400
Message-ID: <20871DCE-E8A3-44E3-991B-6237A44E6BC3@redhat.com>
References: <E2135ED2-AC92-48FE-843E-9E8C83B12729@redhat.com> <87tz51dmmu.fsf@frosties.localdomain> <FF2073B4-6922-4D16-8FA7-90C66071C6F6@redhat.com> <155bf3edda1c2692d316807ff5f58f30.squirrel@neil.brown.name> <029B34A7-B30F-4BCC-A485-530EAC76C059@redhat.com> <18908.17995.353779.708803@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-74--994871604"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18908.17995.353779.708803@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, LinuxRaid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-74--994871604
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 8, 2009, at 2:38 AM, Neil Brown wrote:
> On Tuesday April 7, dledford@redhat.com wrote:
>>
>> I disagree.  At least in our case, the reason that /var/run is a real
>> directory is not to preserve ownerships (although it does do that as
>> well), but to preserve security context for SELinux.
>
> Ahhh... well SELinux and I have never seen eye-to-eye either :-)

;-)

>>> I have to say that putting the map file in /dev feels very icky
>>> to me.  It isn't a device, and so doesn't belong in /dev.
>>> If we go around putting things somewhere convenient rather than
>>> where they belong, we quickly end up with a mess.
>>
>> If that's the case, then all of udev's library data in /dev/.udev
>> doesn't belong there either.  And as much as this may not be a  
>> device,
>> it is in fact device specific in that it maps one device to another.
>> It really is right along the lines of the data udev stores in .udev,
>> so I don't see the ickyness.
>
> You don't think that /dev/.udev is icky?

The whole concept of device files was a hack to enable the "everything  
is a file" semantic.  There are so many things I find icky about  
device files/enumeration in general that I find it very difficult to  
get uppity about what belongs in /dev...the whole thing is a steaming  
pile of...

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-74--994871604
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkneTHUACgkQQ9aEs6Ims9j+pACaA/JiE89om1T8Gb0AROYxsBIc
B6gAoOSjPj3QixHx46munjfWQ2KzTBKM
=77QZ
-----END PGP SIGNATURE-----

--Apple-Mail-74--994871604--
