From: "Ryan B. Lynch" <rlynch@strozllc.com>
Subject: Re: Partition or whole disk ?
Date: Wed, 30 Jun 2004 08:09:27 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406300809.28587.rlynch@strozllc.com>
References: <1088604941.2840.1.camel@JubJub> <20040630145547.GV29086@lug-owl.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040630145547.GV29086@lug-owl.de>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Wednesday 30 June 2004 02:55 pm, Jan-Benedict Glaw wrote:
> On Wed, 2004-06-30 10:15:41 -0400, Josh Litherland <josh@emperorlinux.com>

> I can't remember any recommendation being spoken out ever. Personally, I
> prefer having a number of partitions, but that's not a general guide for
> everybody else:)
>
> > Is there any functional reason why either one is better ?

Isn't it true that autodetection won't work if you build it out of whole 
disks, though?  The kernel looks for "fd" type partitions to add to RAID 
arrays on boot and sets them up according to their superblocks.  An array 
made of whole-disks couldn't have partition types, so it couldn't use this to 
setup.

This is my understanding, so if I'm wrong, please let me know.

- -Ryan
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA4nU3KQgTRJGqPXQRAgE7AJ49oaNdKngkoQEWdXbqd0SuGtjq9wCfbE0t
yqLMf/+Ehn8+ST56+HJMxcQ=
=ZgQv
-----END PGP SIGNATURE-----
