From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: assemble vs create an array.......
Date: Fri, 30 Nov 2007 20:40:18 +0300
Message-ID: <47504B02.3030700@msgid.tls.msk.ru>
References: <474F869D.5040503@mpigani.org> <47502406.8080809@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47502406.8080809@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>
Cc: Dragos <dragos@mpigani.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryce wrote:
[]
> mdadm -C -l5 -n5 -c128  /dev/md0 /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdc1 /dev/sdd1
...
> IF you don't have the configuration printout, then you're left with
> exhaustive brute force searching of the combinations

You're missing a very important point -- --assume-clean option.
For experiments like this (trying to figure out the order of disks),
you'd better ensure the data on disks isn't being changed while
you try different combinations.  But on each build, md always
destroys one drive by re-calculating parity.  You have to stop
it from doing so - to not trash your data.

Another option is to use one missing drive always, i.e.,

 mdadm -C -l5 -n5 -c128  /dev/md0 /dev/sdf1 missing /dev/sdg1 /dev/sdc1 /dev/sdd1

so that the array will be degraded and no way to resync anything -
this also prevents md from trashing data.

/mjt
