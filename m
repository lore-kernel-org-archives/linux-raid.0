From: Phil Turmel <philip@turmel.org>
Subject: Re: Renaming MD devices (metadata=1.1)
Date: Tue, 10 Jan 2012 07:49:58 -0500
Message-ID: <4F0C33F6.4050705@turmel.org>
References: <4F0BD6EA.8010007@grm.polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0BD6EA.8010007@grm.polymtl.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Gilbert Kowarzyk <kowarzyk@grm.polymtl.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/10/2012 01:12 AM, Gilbert Kowarzyk wrote:
[...]
> I have since redone these steps saving the changes in the
> /etc/mdadm.conf file, but after a reboot the same thing happens
> (despite the /etc/mdadm.conf file saying otherwise).
> 
> So, I've run out of ideas... help?

You might just need to update your initramfs.  It needs to have its
own copy of mdadm.conf for use before the root filesystem is
mounted.

I don't use CentOS or its upstream, so I'm not sure what command
will do this for you, but I suspect it is well documented. :-)

HTH,

Phil
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8MM/QACgkQBP+iHzflm3AZYQCcDducIPM4rchAtsWWYLw3DViS
xiAAnR0MYlY47HlkypA98x3xyLErnxoy
=n3cC
-----END PGP SIGNATURE-----
