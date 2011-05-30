From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: filesystem-level tool to validate array
Date: Mon, 30 May 2011 10:13:52 +0300
Message-ID: <4DE343B0.20908@oldum.net>
References: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=9mp0v4kn+3ZZP7CtBxE88Ox3_rA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Stumpf <mjstumpf@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
perhaps a complete fs check via fsck ?

Cheers,
- -Nik



On 05/29/2011 11:17 PM, Michael Stumpf wrote:
> I'm looking for a filesystem-level tool to perform something similar
> to what badblocks does at the drive level.  I can certainly write it
> on my own (I'd build it as a Perl or Python script), but if someone's
> already invented this..
> 
> (The intended purpose is to validate that there are no quirks/bugs in
> the overall fs.)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJN40OwAAoJEDFLYVOGGjgXEfMH/3EuiJMEIH25WAFbfdv4lgl/
vDvFvb7BpPugnws4qffyJ3cWZu/g39OjrvvAf00xFZXy+OYv0mTtdnNiDBZh/3Tp
lT+p4b1zNsb9yujEFM0OhjaDjq89FytRNHIIPXl9OtvAWi/z+JdGY9ucyFqjl04L
EUaur3ofW0ys1rCLFHvk7Lg3F74E0wk/5v7Ivlop4ECYbgbzM56sLIZ1b980GWCF
kLlz1OdakoZw3Zl9LOdGVqOtmd2PJrhUzYjILSgUIPTVjAFLbKt9oEE1Y5uBJOhm
e5bY9K7YuYVnQ52Vmbz7Y4nxdIAGHp7NDne2jQoGhObKlbzoth4k/IOE6SoR3R4=
=r5BC
-----END PGP SIGNATURE-----
