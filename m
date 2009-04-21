From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 20:00:59 -0400
Message-ID: <B982A8CB-4054-4F17-B269-A737462B2A81@redhat.com>
References: <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090420212444.GA5193@lazy.lzy> <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-32--28145055"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-32--28145055
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 20, 2009, at 7:47 PM, Doug Ledford wrote:
> And so the confusion is perpetuated.  This is *not* accessing a  
> device by name.  If I give mdadm a name for my device, I don't want  
> it doing *anything* with numbers, creating numbered symlinks, or  
> anything else.  In addition, if I tell mdadm to create something in / 
> dev/md/ (versus it decided all on its own to create something  
> there), then I do *NOT* want it creating *anything* in /dev/ that I  
> didn't ask for.  That, again, adds to the confusion.  Of all of it  
> though, the /proc/mdstat is the worst part as it underscores that  
> the kernel stack is not able to think in terms of names instead of  
> numbers.


Actually, I want to expand on this thought for a little bit.  I'm  
obviously harping on all the symlinks and stuff that mdadm creates  
when you tell it what you want it to do.  I know these were added for  
back compatibility reasons.  However, the problem I have is that I  
work on mdadm for a living (well, sorta, I have 30+ other packages I  
also maintain, many of them orders of magnitude larger than mdadm, and  
I do kernel work, so my mdadm specific time is fairly small, but still  
it's paid time), and I've sat down before and tried to figure out "if  
I use name 'X' for my array, what device file gets created".  The net  
result of my attempts to do that, were that I was never able to figure  
out just by running mdadm what the proper syntax for the name variable  
is/was.  It always created so many symlinks to cover all possible  
cases that I never could get it to do what I wanted, and *just* what I  
wanted.  In short, mdadm as it currently stands errs on the side of  
caution and back compatibility, but it does so to such an extent that  
you can never get things wrong.  And if you can never get things  
wrong, you can never figure out how to get things *right*.  We either  
have to create every possible compatibility symlink forever, or  
*sometime* we have to turn that off and just let people figure out how  
to get this stuff right.  But right now, no one is making any progress  
because it's hidden by mdadm trying to cover our asses for us.

--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-32--28145055
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkntDLwACgkQQ9aEs6Ims9jb1QCgl1zcQjuDWWAFIawcD3SwMwrL
R9UAnj9uzlMt7nAvuK9dJOB13igqknlW
=wCqP
-----END PGP SIGNATURE-----

--Apple-Mail-32--28145055--
