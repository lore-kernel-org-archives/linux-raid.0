From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 19:47:36 -0400
Message-ID: <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com>
References: <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090420212444.GA5193@lazy.lzy>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-31--28948496"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090420212444.GA5193@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-31--28948496
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 20, 2009, at 5:24 PM, Piergiorgio Sartor wrote:
> On Mon, Apr 20, 2009 at 11:13:32PM +0200, Luca Berra wrote:
>> add --auto=md to the command line
>> or put it in the create line in mdadm.conf
>
> Thanks, that did the trick!
>
> Interesting, it seems now I have 3 devices
> for that raid.
> One is /dev/md127, one is /dev/md/boot, with
> same (major, minor) as md127, and there is a
> third one, /dev/md_boot, which is a symbolic
> link to /dev/md/boot.
>
> /proc/mdstat reports /dev/md127

And so the confusion is perpetuated.  This is *not* accessing a device  
by name.  If I give mdadm a name for my device, I don't want it doing  
*anything* with numbers, creating numbered symlinks, or anything  
else.  In addition, if I tell mdadm to create something in /dev/md/  
(versus it decided all on its own to create something there), then I  
do *NOT* want it creating *anything* in /dev/ that I didn't ask for.   
That, again, adds to the confusion.  Of all of it though, the /proc/ 
mdstat is the worst part as it underscores that the kernel stack is  
not able to think in terms of names instead of numbers.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-31--28948496
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkntCZgACgkQQ9aEs6Ims9iWtgCg2T+9m7vQz8CY5VraPkEAkXiO
+s4An2RPdTewzbN4yuuhkDnJTzkU7X1G
=lwU4
-----END PGP SIGNATURE-----

--Apple-Mail-31--28948496--
