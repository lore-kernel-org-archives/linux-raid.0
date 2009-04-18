From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 09:35:33 -0400
Message-ID: <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090418081239.GB2124@maude.comedia.it>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-8--238471793"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090418081239.GB2124@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-8--238471793
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 18, 2009, at 4:12 AM, Luca Berra wrote:
> On Fri, Apr 17, 2009 at 02:17:47PM -0400, Doug Ledford wrote:
>> This appears to be the difference between a server setup and a  
>> desktop setup.  Server admins want to list things and only have  
>> known actions happen.  Desktop people want things to "just work".   
>> I've had several people tell me they thought the idea of mdadm.conf  
>> was completely out of date and it should just go away entirely.   
>> Not saying I agree, just letting you know what I get.
> uhm, udev should be able to assemble an array without mdadm.conf, not
> that i like it

It does, the question is whether or not it should honor the preferred  
minor when it assembles an array not in mdadm.conf.

>>> Parts of what you are proposing seem to involve expecting people to
>>> take a middle ground with some arrays listed in mdadm.conf and other
>>> that aren't.
>>
>> I do this myself FWIW.  My / and /boot arrays are in mdadm.conf,  
>> but arrays that I plug in via USB, eSATA, etc. are not.
>>
>>> I'm not sure I'm happy with expecting people to do that
>>> (though of course I'm happy to support it).
>>
>> I really don't expect them to per se.  More like it's the *safe*  
>> thing to do.  If you ever have a conflict in names, the one in the  
>> file wins.  If you ever have a conflict in names without one of  
>> them in the file, then it's whoever got there first.  In that  
>> sense, mdadm.conf is just a backup for me.  Well, that and mkinitrd  
>> doesn't do incremental assembly, so it's needed for boot in my  
>> case.  But that could be changed.
> yes, if we ensure it will mount the correct array :)

With my patch (which Neil didn't like), it does.

> i was wondering about indicating our preference to policy in  
> mdadm.conf
> ie
>
> POLICY {dynamic|preferred|strict}
>
> dynamic: assemble anything you find, naming policy first come first
> served. this might be the only line in mdadm.conf
>
> preferred (in need of a better name): arrays defined here have
> precedence over dynamically found arrays
>
> strict: if it ain't here, just ignore it
>
> ....
>> This is a bad idea, and just reinforces my thought that we  
>> shouldn't be paying attention to homehost.  Amongst the most  
>> important aspects are machines that are booted up, installed, raid  
>> arrays created during install, then shut down and moved, likely  
>> changing dhcp hostnames in the process.  Now all your homehosts  
>> belong to some hostname in some IT guys install network instead of  
>> in your final network.  At install time, it's actually fairly  
>> common that the hostname is not yet set, especially at raid array  
>> creation time.
> i never found much use for homehost, i would prefer to have a stricter
> locking mechanism for shared storage (maybe integration of cman
> locking???) and leave the desktop world with randomic names.
> If you get the first case wrong you risk damaging data.
> If you get the array name wrong on a desktop i expect the luser will
> never even notice as long a windows pops up showing the filesystem
> contents :P


I've been thinking about this, and this is the method I would suggest.

Add two new keywords to the mdadm.conf file:

ASSEMBLE
INCREMENTAL

Allow each of those keywords to have one of three set values:
None - Don't attempt to assemble any arrays regardless of whether or  
not they are in the mdadm.conf file or not
Known - Only assemble arrays with a matching array line
All - Attempt to assemble any array found

The combination of the two options and the three settings would allow  
you to control mdadm behavior for both array assembly modes  
independently.  That, combined with my previous patch, should allow  
arrays to assemble well, with known names, allow you to control auto  
assembly by udev, and in the event that your machine just exports  
volumes to other machines for their use, stop assembly entirely.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-8--238471793
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknp1ysACgkQQ9aEs6Ims9hC9QCglaAxsno1m/sIatE/ttH59fes
sO4An0SxfTFqhaJD9H/nTo9jnY8vQWYh
=731z
-----END PGP SIGNATURE-----

--Apple-Mail-8--238471793--
