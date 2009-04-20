From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 08:36:14 -0400
Message-ID: <FC4D5084-916A-4F07-9AF8-C00053255CA7@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090418081239.GB2124@maude.comedia.it> <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com> <18924.4416.635979.452887@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-15--69229908"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18924.4416.635979.452887@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Luca Berra <bluca@comedia.it>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-15--69229908
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 20, 2009, at 2:08 AM, Neil Brown wrote:
> On Saturday April 18, dledford@redhat.com wrote:
>>
>> I've been thinking about this, and this is the method I would  
>> suggest.
>>
>> Add two new keywords to the mdadm.conf file:
>>
>> ASSEMBLE
>> INCREMENTAL
>>
>> Allow each of those keywords to have one of three set values:
>> None - Don't attempt to assemble any arrays regardless of whether or
>> not they are in the mdadm.conf file or not
>> Known - Only assemble arrays with a matching array line
>> All - Attempt to assemble any array found
>>
>> The combination of the two options and the three settings would allow
>> you to control mdadm behavior for both array assembly modes
>> independently.  That, combined with my previous patch, should allow
>> arrays to assemble well, with known names, allow you to control auto
>> assembly by udev, and in the event that your machine just exports
>> volumes to other machines for their use, stop assembly entirely.
>
> Why "None"??  Why would you use "None" rather than "Known" with an
> empty list of arrays?

For the same reason we have a write-mostly flag for raid1.  Maybe we  
have two machines that both want/need to know about a given array, but  
only one should access it at a time (clustered failover scenario).  On  
the non-primary node, you use None, on the primary you use Known, and  
bootup proceeds properly.  Then on failover, on the non-primary  
machine you already have the array in mdadm.conf and can bring it up  
safely and reliably in manual operation.  This requires that mdadm  
tell the difference between manual and automatic mode (aka, from a  
command line instead of a shell script), so you need a new option flag  
to override the assembly/incremental settings, but that's the only  
change necessary.

> Why have two options: ASSEMBLE and INCREMENTAL ??
> If what circumstance would you use different settings for these two
> options.

I can't speak to other distros, but at least Fedora still does  
assembly on bootup, and incremental after bootup (well, we switch to  
incremental part way through bootup, mainly once rc.sysinit has  
completed).  Maybe you have a machine that exports raid block devices  
via AOE, and these are always present at bootup, so you want ASSEMBLY  
to none.  Yet, you also plug in a roving USB disk array for online  
backups, so you want that to come up via hot plug.  There are lots of  
reasons things might be done.  I just suggested a method that is  
flexible enough to satisfy even the most whacked out scenario.

> I current have two patches sitting in my scratch queue.  I am by no
> means committed to them.
>
> One allows you to have e.g.
>
>  ARRAY ignore UUID=foo:bar:dead:beef
>
> with the meaning that auto-assembly will ignore that array.  If you
> run
>
>  mdadm --assemble /dev/md/thing --uuid foo:bar:dead:beef
>
> it will still assemble the array, but any auto-assembly will ignore
> it.
>
> The other allows you to say:
>
> AUTO -ddf -0.90 +all
>
> which means don't auto-assemble any 'ddf' or '0.90' array, but do
> auto-assemble anything else that is recognised.
> You might want to use dmraid for ddf??
>
> If you just have
>
>  AUTO -all
>
> then it won't auto-assemble anything, which is much like your
>  ASSEMBLE  Known
>  INCREMENTAL Known
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-15--69229908
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknsbD8ACgkQQ9aEs6Ims9hqmQCdFYvRXTMkZaXoMWjsww/7Gvb0
kU8AoKs2MldZPRomiutWpQpcOabrIWRs
=0bLN
-----END PGP SIGNATURE-----

--Apple-Mail-15--69229908--
