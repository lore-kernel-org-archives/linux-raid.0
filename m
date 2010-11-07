From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Superblock V 1.2
Date: Sun, 7 Nov 2010 15:03:39 -0600
Message-ID: <E9.7C.19545.72417DC4@cdptpa-omtalb.mail.rr.com>
References: <20101107191507.GA31052@cons.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101107191507.GA31052@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Martin Cracauer' <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Martin Cracauer
> Sent: Sunday, November 07, 2010 1:15 PM
> To: linux-raid@vger.kernel.org
> Subject: Superblock V 1.2
> 
> I created a new array after upgrading kernel and OS
> (2.6.32.25-cracauer and Debian/squeeze, respectively, resulting in
> mdadm - v3.1.4 - 31st August 2010)
> 
> The new array reads
> md0 : active raid5 sdc2[4] sda2[2] sdb2[1] sdd2[0]
>       292998144 blocks super 1.2 level 5, 256k chunk, algorithm 2 [4/4]
> [UUUU]
> 
> I figure the "super 1.2" means the new version of the superblock.

	It's one of the new versions, yes.  Your statement suggests there is
only 1 new version.

> Can I read that array if I ever connect the machine to an older
> kernel/mdadm?

	That depends on just how old.  The new superblocks have been
supported for quite some time.  Worst case you will need to upgrade the old
kernel to a newer one.

> I see that I can control which version to use in
> mdadm(8), but I don't get what the advantage of the new format is if I
> don't run out of # of components or total capacity.

	The older 0.90 superblock is still quite serviceable for many uses,
but unless the array is to be booted, I would recommend a 1.x superblock.

> I can see how
> storing the superblock at 4 KB makes it more robust against accidents
> that wipe out of the first 512 bytes or similar fun.  I think storing
> it at the end will be a pain if you ever have to hexdump recover the
> thing, no?

	Each one has its strong points and it drawbacks.  You've got to
decide which one will likely serve you best given your approach to managing
your system.

