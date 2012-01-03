From: Phil Turmel <philip@turmel.org>
Subject: Re: Is this RAID recoverable???
Date: Tue, 03 Jan 2012 09:34:23 -0500
Message-ID: <4F0311EF.9010102@turmel.org>
References: <CAHw_BJ3fGd2ZN5ORs4+DSxz57AhT6jq7oL+cs_4MaztZX0sgUQ@mail.gmail.com> <20120103153757.5487e6fa@natsu> <4F0301F0.40206@turmel.org> <CAHw_BJ3qH+BgAxY3PHFUU_CH2EDf88xvn6V=rV71fzA-xUcLvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHw_BJ3qH+BgAxY3PHFUU_CH2EDf88xvn6V=rV71fzA-xUcLvw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Richter <iamcomcy@gmail.com>
Cc: Roman Mamedov <rm@romanrm.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Paul,

[Please avoid top-posting on kernel.org lists]

On 01/03/2012 09:22 AM, Paul Richter wrote:
> Hi Phil!
> Thanks for throwing in! Do you have the older default values? I
> suredon't. And how do you add offsets the the --create command?
> mdadm --create --assume-clean /dev/md1 --chunk=4096
> --level=6--raid-devices=6 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sde1
> missingmissing
> Is what I am working with now.
> Many thanks!

The "data offset" is not settable from the command line.  The modern
default is 1MB == 2048 sectors.  The prior default was something like
264 sectors.  To get it, you need to grab an older version of mdadm
(just for the --create operation).

> This 8TB represents the last 8 years of my life on the net. Built
> thisRAID to protect that 'investment'. :'-(

RAID != backup.  A common misconception.

> TIA

You're welcome.

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8DEe0ACgkQBP+iHzflm3BVIwCfUvkQzKfrG4oFM2XDf4pVzfCR
EWgAnjPAsLVYkqZmol/WDhaDieEuWFw0
=8QkU
-----END PGP SIGNATURE-----
