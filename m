From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm question
Date: Sat, 21 Aug 2004 08:11:54 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16678.30506.677976.584229@cse.unsw.edu.au>
References: <41262445.8010509@aj.net-lab.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andreas John on Friday August 20
To: Andreas John <lists@aj.net-lab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday August 20, lists@aj.net-lab.net wrote:
> Hello!
> 
> I have a question about mdadm usage. One of me customers killed a
> raid5+1 by accidently removing an ide bus with two disk on it (dont't
> ask, I know ;-))
> 
> Assuming that the data is on the disks I'm looking for a way to convince
>   linux to mark the superblocks (of the missing disk only?) as "not
> failed" so that the raid comes up again. mdadm seems to have what I am
> looking for, like "madm --assemble --update=? --force" can write the
> superblocks freshly without destorying the data on it? Do I have to use
> --update=super$,1rp(Bminor or --update=super$,1rp(Bminor on ia32?
> Or is there an recovery tool for such a case (i.e. mddump?)?

You don't need any --update.  Just --assemble --force.  mdadm will
then pick the best available drives to assemble a degraded array (one
drive missing).  If the result seems good (e.g. fsck reports ok), then
you can add the other drive (--add) and it will be reconstructed with
consistent data.

NeilBrown

> 
> If this does not work, can anyone point me out where I can find an
> overview about the structure of a superblock, so that I may fix the
> problem via hex-editor (my skills point back to C64 times ... :-))
> I've seen the source but some kind of overview/scheme would be nice.
> 
> I'm scared. :)
> 
> Rgds,
> Andreas
> 
