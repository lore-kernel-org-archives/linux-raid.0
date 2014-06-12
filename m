From: Roman Mamedov <rm@romanrm.net>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 14:06:44 +0600
Message-ID: <20140612140644.352e8c69@natsu>
References: <5397FBCE.3060009@bartk.us>
	<53990D44.300@fnarfbargle.com>
	<20140612122814.2db74377@natsu>
	<5399561A.4030405@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/l4TlqCVI4w/GNkYnofuDggL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5399561A.4030405@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/l4TlqCVI4w/GNkYnofuDggL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jun 2014 09:26:18 +0200
David Brown <david.brown@hesbynett.no> wrote:

> Secondly, hard disks already have ECC, in several layers.  There is
> /far/ more error detection and correction on the data read from the
> platters than you could hope to do in software at the md layer.  There
> is nothing that you can do on the md layer to detect bad reads that
> could not be better handled on the controller on the disk itself.  So if
> you are getting /undetected/ read errors from a disk (as distinct from
> /unrecoverable/ read errors), then something has gone very bad.  It is
> at least as likely to be a write error as a read error, and you will
> have no idea how long it has been going on and how much of your data is
> corrupt.  It is probably a systematic error (such as firmware bug) in
> either the disk controller or the interface card.  Such faults are
> fortunately very rare - and thus very rarely worth the cost of checking
> for online.

In one case which Brad was describing, it was a hardware design fault in his
RAID controller, resulting in it returning bad data only when all ports are
utilized at high speeds. If MD had online checksum mismatch detection, it
would alert him immediately that something's going wrong, rather than have
this bug happily chew through all his data, with "months of read/modify/wri=
te
cycles combined with corrupt data spread the corruption all over the array".

> And since an undetected read error is not just an odd occasional event,
> but a catastrophic system failure, the correct response is not
> "re-create the data from parities" - it is "full scale panic - assume
> /all/ your data is bad, check from backups, call the hardware service
> people, replace the entire disk system".

Sure, it could and should loudly complain with "zomg, we just had a data
corruption and had to correct it from parity" messages to dmesg.

> Another is to maintain and check lists of checksums (md5, sha256, etc.)
> of files - this is often done as a security measure to detect alteration
> of files during break-ins.

Not always feasible at all, in case of e.g. VM images, including those of
"other" operating systems, also in case of e.g. actively modified databases.

> Finally, you can use a filesystem that does checksumming (it is vastly
> easier and more efficient to do the checksumming at the filesystem level
> than at the md raid level) - btrfs is the obvious choice.

Btrfs could not be further from the obvious choice at the moment, as Btrfs
RAID5/6 support is still in its infancy.

Sure you could use Btrfs in a single-device mode over MD; then it would det=
ect
any checksum errors as they happen. But of course it will not be able to
correct them.

Which is sad, since MD (on RAID6) *has* all the parity information needed to
recover a read error, and there isn't even any need for a special filesystem
on top of it, but it's like it just won't help you, almost out of principle.

> If you disagree so strongly, you are free to do something about it.  The
> people (Neil and others) who do the work in creating and maintaining md
> raid know a great deal about the realistic problems in storage systems,
> and realistic solutions.  They understand when people want magic, and
> they understand the costs (in development time and run time) of
> implementing something that is at best a very partial fix to an almost
> non-existent problem (since the most likely cause of undetected read
> errors is things like controller failure, which have no possible
> software fix).  Given their limited time and development resources, they
> therefore concentrate on features of md raid that make a real difference
> to many users.

Absolutely, however the thing is, having a mode to always full-check RAID1/=
5/6
reads does not even seem like an extremely complicated feature to implement;
it's just the collective echo chamber of "this is useless; we don't need th=
is;
md is the wrong place to do this; etc" that discourages any work in this ar=
ea.
And those who think that on the contrary this is a good idea (as Brad said,
"this comes up at least once a year") typically lack the necessary experien=
ce
with the MD or kernel programming to implement it themselves.

> However, this is all open source development.  If you can write code to
> support new md modes that do on-line scrubbing and smart recovery, then
> I'm sure many people would be interested.  If you can't write the code
> yourself, but can raise the money to hire a qualified developer, then
> I'm sure that would also be of interest.

Sure, but that also does not stop me from doing my part by whining^W provid=
ing
valuable input on mailing lists, to signal to any interested developers that
yes, that's indeed one feature which is very much in demand by some users in
the real world :)

--=20
With respect,
Roman

--Sig_/l4TlqCVI4w/GNkYnofuDggL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOZX5QACgkQTLKSvz+PZwifbwCggammQjXEepJ6gFoekrWKBD/H
srUAoITkSyAvTzEm+5kyHsYb6NOp9nuu
=ij+x
-----END PGP SIGNATURE-----

--Sig_/l4TlqCVI4w/GNkYnofuDggL--
