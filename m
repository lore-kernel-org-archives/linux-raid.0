From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Intel fakeraid working?
Date: Mon, 23 Apr 2012 00:06:33 -0400
Message-ID: <4F94D549.4050308@ubuntu.com>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown> <4F7DE314.9040306@ubuntu.com> <20120406092428.1090e10b@notabene.brown> <4F7E426F.5000604@ubuntu.com> <20120410094330.00fb2477@notabene.brown> <4F843252.5090109@ubuntu.com> <20120423122520.289cad2f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120423122520.289cad2f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/22/2012 10:25 PM, NeilBrown wrote:
> md does set the same flag that "blockdev --setro" sets.  If some filesystem
> writes anyway, then it is definitely a bug and should be fixed.

It sounds like that's what happened in this case.

> So it looks like everybody is doing the "right" thing (allowing for
> occasional bugs here and there), and your real problem is just that Ubuntu
> didn't package mdmon.

The lack of mdmon certainly is a problem, but triggering that BUG_ON when it is missing seems to point to a bug somewhere in the kernel.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPlNVJAAoJEJrBOlT6nu75VmQIAKTl4VPgadyeV1xpzJzFmPKP
YX9MZf8cZgcrmy1qRZrJLGa9Yfd6A8L0sp9Y4kzUM7pvPsmxG6uDr+iBsxx6MkJZ
cBbpIxuIiB1zwOIR6YcvyCG2htZxqS11ZFzZL+fIFTI9OXMgdBbHJoMRm1S6XdE4
erKhYhrAD31tKcHV1RIOFSAf8GMUsn5iUzdO6YpBefVjmCodJMMeaUyxIoMLrIC1
jWzS8Iu30L0fn2kyOWLaLvkupVTe1TG4hThWrdHkb/sUCEmcuSp2YJ7uMgL7Jwn+
A4hr+yOXnKZmTnYlJcL4fg4xvavcaKqirZYYmcdv5OmIHwcfYORdkHAP2m5G4pQ=
=w81A
-----END PGP SIGNATURE-----
