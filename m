From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Intel fakeraid working?
Date: Thu, 05 Apr 2012 21:10:07 -0400
Message-ID: <4F7E426F.5000604@ubuntu.com>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown> <4F7DE314.9040306@ubuntu.com> <20120406092428.1090e10b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120406092428.1090e10b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/05/2012 07:24 PM, NeilBrown wrote:
> Something wrote to the md device despite it being marked 'read-only'.
> Some filesystems do that to replay their journal.  totally inexcusable
> behaviour, but what can we do....

I agree... read-only means read ONLY.

> I'm surprised that would happen during installation though.
> But certainly the array is marked read-only, and certainly something is
> writing to it, and that is the real bug.

If the block device is flagged as read only, then shouldn't it reject write attempts even if the fs or userspace issue them?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPfkJpAAoJEJrBOlT6nu75GUMH/jcgx+iMzZKICCKmwnU3IA9K
LTjC95EmOrq7Twt5e77D5rePTZqWZKzDyNEkiZ8hwOHvg+ohyKA7HA42DPIBpfT2
Fb5urHbhtVwLHNeusQPOIOX5psByEFjhlz/CgjuAaZjlsOu5VY6CXtdkPOdO65GC
XnOIlJpUAvUhvv9x9bFT1d4TjmcvDTt4hrErBUhHPMPXJGSY7/24G1wjgWLAUx3w
cR8YHChLAgJ9PAYHLCNINyTVQGdET9sLHqTSMjxrp2tryDh3IDBNGxUSRMzrPaJd
EprVL+3BmH0J9bHLuUfkr/q/zZrHxGF8F4ePi+lvXsNqPIKuXdN68KJgU9KeTL4=
=JG+f
-----END PGP SIGNATURE-----
