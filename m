From: Jim Ramsey <jwramsey@pobox.com>
Subject: Re: where to buy very very large cases
Date: Mon, 28 Jul 2003 10:21:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307281021.45794.jwramsey@pobox.com>
References: <bWpzdHVtcGY=.14a9e78b52177716d8df11d88fc1d02c@1059398282.cotse.net> <Pine.LNX.4.55.0307281006480.22915@datavibe.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0307281006480.22915@datavibe.net>
Content-Description: clearsigned data
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

A verry big AMEN about cooling.

Servers are up all the time.  If you want your drives to last as long as
possible, cool the enclosure well.  Keeping the drives cool can help
them last longer, but almost more important is keeping the drives at
a STABLE temperature.  You also want to invest good money in a high
quality power supply -- not just big (in terms of watts), but good.
Again supplying high quality, stable DC power will help make the
entire system generally more stable and reliable.

On Monday 28 July 2003 10:11, Rev. Jeffrey Paul wrote:
> On Mon, 28 Jul 2003, mjstumpf wrote:
> > I need to expand an x86-based fileserver that's already stacked with 11
> > drives.  Where have you folks found reasonably-priced very very large ATX
> > cases?  I need to go to 20 or so drives, but I'd like to hear the upper
> > limit you have all found..
> >
> > Are there other means of packing more drives into a small space -- IE,
> > has anyone actually fabricated a bracket that would take multiple
> > vertical 5.25" form factor spaces, and let you mount 3.5" drives sideways
> > [vertically] to pack 4 drives into the space of 3.. etc..
> >
> > May have to resort to home depot PVC + jigsaw + zipties.. !!
>
> While I'm all for the home depot engineering (i just made ten sets of rack
> rails for $11 each whereas OEM ones for our ibm servers were >$200 each),
> i don't think that's your best bet in this case.
>
> What type of interface do the drives have?  If they're LVD SCSI, you might
> be better off with an external drive enclosure (they're designed to fit
> many drives in small spaces, with proper cooling and power to boot)
> connected to a VHDCI external connector on your scsi or raid card.
>
> Someone (3ware?) should make an IDE drive cage with a custom backplane and
> an integrated IDE RAID card... and a VHDCI plug for an uplink to the host.
> That would be cool.
>
> -j
>
> --
> --------------------------------------------------------
>  Rev. Jeffrey Paul    -datavibe-     sneak@datavibe.net
>    aim:x736e65616b   pgp:0x15FA257E   phone:8777483467
>     70E0 B896 D5F3 8BF4 4BEE 2CCF EF2F BA28 15FA 257E
> --------------------------------------------------------
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

- -- 
Regards,

Jim Ramsey

  There's that that's worth living for.
  There's that that's worth dying for.
  The rest is c**p.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/JTF5DGYt4MQyo3IRAgP0AKCsbXNz9okedu0f80Asbt1uFygJHwCfUqWG
wxMK6ktRGFylu6aegpwr02U=
=8ANn
-----END PGP SIGNATURE-----

