From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: What just happened to my disks/RAID5 array?
Date: Wed, 14 Sep 2011 20:17:12 +0200
Message-ID: <4E70EFA8.4080706@truschnigg.info>
References: <4E6F13F7.6070507@truschnigg.info> <4E6F4091.7050206@turmel.org> <4E6FA76A.90206@truschnigg.info> <4E7092F1.5010209@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig356ED2F42C2929B5E7F85B8E"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7092F1.5010209@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig356ED2F42C2929B5E7F85B8E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello again Phil (and of course alco possible bystanders :))!

On 09/14/2011 01:41 PM, Phil Turmel wrote:
> Good Morning Johannes,
>=20
> Sorry about the delay...  worked late yesterday.

Really no need to be sorry about anything; actually I'm perfectly aware
that I'm not entitled to any kind of your support, and I greatly
appreciate it whenever you volunteer to share your insights with me. So
let me say thank you very, very much for getting back to me again in
this regard!

>> The controller seems alive still - lsdrv (output attached) lists=20
>> the kernel still having registered some of the component devices.
>=20
> Actually, it doesn't.  None of the /dev/md0 components are present.=20
> Ditto for the "mdadm -D" report.

You are right; none of the disks were present once I got to the machine.
The lvm and fs on top seemed rather confused about what happened, and I
went on to kill all processes with file handles open on the fs in
question, unmounted the fs, and rebooted. The board's BIOS took an
awkwardly long time when scanning for SATA devices on the SB's ports,
but in the end showed all of them in the POST screen. After booting the
kernel, one of the drives popped out rather early in the process (about
two or three seconds after the kernel picked it up), and all subsequent
reboots (even when disconnecting the failed and/or all but one drive(s))
make the box hang indefinitely upon POSTing and scanning the SATA
controller. My guess is that the board/controller is fried.

> [...] "--assemble" is safe in all known cases.  Use it first.  With=20
> the whole controller gone, you probably have consistent event counts=20
> after all, and --assemble should just work.  "--assemble --force" is=20
> somewhat less safe, but I wouldn't hesitate to use it in a situation=20
> where the drives truly dropped out together.  You'll likely find some
> problems with fsck if files were actively being written when the=20
> array dropped out, but the vast majority of your filesystem(s) should
> be safe.

Thanks, I will try that as soon as I can get my hands onto a machine
with enough free SATA ports - I might have to replace the whole system
(at least board, CPU and RAM) and will have to do some research before
settling for specific hardware. I can do without that part of my data
for a few days, probably even weeks, but losing it forever would be hard
to swallow still.

> Other procedures are progressively less safe.  I prefer to not offer=20
> specifics until you've hooked your drives back up, and generated=20
> fresh "lsdrv" and "mdadm" reports.

I promise I'll get back to the list if --assemble doesn't do its deed
right away once I got a system put together that can handle all the
array's member devices.

Again, thank you very much for your time and sharing your expertise!

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.


--------------enig356ED2F42C2929B5E7F85B8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5w760ACgkQnnUApj8OcoI+8wCfSTWU9dcwUN6shi7SXC02NECP
8XgAnRTvFFInr5Lh7Rf9cnZeDtSklMxJ
=0Pku
-----END PGP SIGNATURE-----

--------------enig356ED2F42C2929B5E7F85B8E--
