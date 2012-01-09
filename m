From: Phil Turmel <philip@turmel.org>
Subject: Re: recovery from multiple failures
Date: Sun, 08 Jan 2012 19:11:57 -0500
Message-ID: <4F0A30CD.60904@turmel.org>
References: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eu9pt8xa4l.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Keith,

On 01/08/2012 03:12 PM, Keith Keller wrote:
> Hi all,
> 
> I recently had an experience very similar to what's posted on the wiki:
> 
> https://raid.wiki.kernel.org/articles/r/a/i/RAID_Recovery_d376.html

This page describes the older --examine output format, fortunately, since
that is what you seem to have.

> From what I can piece together from the logs, my controller went a
> little crazy, and dropped a whole bunch of drives in a span of about
> 10 minutes.  I attempted to look at the output of mdadm --examine, as
> documented in the wiki, but the format appears to have changed, so I
> am unclear where to go next.
> 
> I'm going to include the entire mdadm --examine output below, but as I
> was looking at it, I was wondering if the analogous scenario to the wiki
> situation is to look at the array slots:
> 
> $ grep Slot raid.status |cut -f1 -d '('
>     Array Slot : 0 
>     Array Slot : 0 
>     Array Slot : 13 
>     Array Slot : 4 
>     Array Slot : 10 
>     Array Slot : 6 
>     Array Slot : 7 
>     Array Slot : 9 
>     Array Slot : 8 
>     Array Slot : 11 
>     Array Slot : 2 
>     Array Slot : 4 
>     Array Slot : 12 

You are confusing "Slot" with "Role", aka "Raid Device".  All of your devices
report their own role between 0 and 8, except for slot #12, which is "empty".

> There are two separate arrays on this box; the problematic one is
> 24363b01:90deb9b5:4b51e5df:68b8b6ea.  Will I be able to recover this
> array with an appropriate mdadm --create --assume-clean command, and if
> so, how would I go about determining the correct order in which to
> specify the drives?  The big confusing part for me is, as a 9 device
> RAID6, I'd expect to see device slots 0-8, but here I see slots 10
> through 13, and I am unclear how to get the order exactly right.

- From what I can see, you should use "--assemble --force".  The wiki does
not recommend this, but is wrong.  There is no advantage to "--create
- --assume-clean" in this situation, and opportunities for catastrophic
destruction.  Only if "--assemble --force" fails, and not from "device in use"
reports, should you move to "--create".

Another word of warning:  Your --examine output reports Data Offset == 264
on all of your devices.  You cannot use "--create --assume-clean" with a
new version of mdadm, as it will create with the new default Data Offset of
2048.

> My mdadm --examine (which I have also saved separately) is below.  If
> you need any more information let me know.  Thanks!

This is very good.  And clearly shows that "--assemble --force" should
succeed.  You will probably want to run an fsck to deal with the ten minutes
of inconsistent data, but that should be the only losses.  A "check" or
"repair" pass should also be run.

HTH,

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8KMMoACgkQBP+iHzflm3CWmACfQqsqxua7Kp9q5ydpPV5Rtxih
Uc0An0rCW6p8ni4caecGLFoLDxin3wEE
=Gnmb
-----END PGP SIGNATURE-----
