From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with
 xfs filesystem by accident
Date: Wed, 21 Sep 2016 22:53:33 +0200
Message-ID: <20160921205333.GB6949@metamorpher.de>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de>
 <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de>
 <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de>
 <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 09:50:45PM +0200, Simon Becks wrote:
> Thank you. I already learned a lot. Your command only shows data for
> all of the 3 disks.

And for the removed disk?

photorec is slow, not sure how long you let it run;
also we don't know the extent of your damages.

You could search for known filetype headers on your own.
Megapixel JPEGs, or multi-megabyte MP3 tracks, might work.

If you find such a file header at $offset of one disk, 
you could look at the same $offset of the other disks, 
and see if you can deduct the disk order, raid layout, 
et cetera from this. So for example if you were using 
the wrong chunk size you should be able to tell from that...

But this is tedious work, usually it's easier to trial&error 
until you come up with the right setting that just works.
Or that would work if it wasn't overwritten... :-/

Regards
Andreas Klauer
