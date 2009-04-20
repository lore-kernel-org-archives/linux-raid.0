From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 08:29:22 -0400
Message-ID: <5D96EEBE-D4F4-460D-B312-F0E5A221986A@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-14--69642449"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18924.3824.677493.129885@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-14--69642449
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 20, 2009, at 1:58 AM, Neil Brown wrote:
> If you use 1.x metadata (e.g. 1.0), then this works nicely.
>
> mdadm --create /dev/md/foo --metadata 1.0 --level .....
>
> This will store the name 'foo' in the metadata and when you assemble
> the array, it will be called /dev/md/foo.
> This will be a symlink to /dev/md125 or something like that, but you
> don't need to care.


I would prefer to see /dev/md/foo as an actual device special file,  
not a symlink, and no /dev/md125 at all.  Additionally, /proc/mdstat  
output doesn't match /dev/md/foo, it matches /dev/md125, so if you  
need to figure out what raid device is /dev/md/foo so you can see its  
status in /proc/mdstat, then you have to dereference the /dev/md/foo  
symlink.  This just highlights the fact that we haven't gotten past  
numbers as our primary way of referring to md devices.  Kill the  
numbers, allow names to be a *sole* means of reference to an array.   
Otherwise, that lingering /dev/md125 just confuses the issue.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-14--69642449
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknsaqgACgkQQ9aEs6Ims9hqQgCdHRnXygjC8Bi+pDEy+NYd4sxb
V5kAoNkXVHvDqZICHqShJcIKQ4iC+Pwv
=0MRu
-----END PGP SIGNATURE-----

--Apple-Mail-14--69642449--
