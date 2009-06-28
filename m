From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Write intent bitmaps
Date: Sun, 28 Jun 2009 13:14:23 -0500
Message-ID: <20090628181428746.EXYX19511@cdptpa-omta03.mail.rr.com>
References: <19002.62697.475588.28776@notabene.brown>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.62697.475588.28776@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>, 'Carlos Carvalho' <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >  >5. What happens if the bitmap is lost or the external drive fills up?
> >
> > No idea.
> 
> If the bitmap is lost, it is just as though you didn't have a bitmap
> (or as though all the bits in the bitmap were set to one).

	OK, what about the thread in this list where (as I recall) the
fellow's bitmap was corrupted or lost and it evidently caused the entire
array to go splat?  That's worrisome.

> The drive filling up is not relevant.  When the bitmap is in a
> separate file, the file is preallocated to be the right size.

	Let me take a little different tack.  I don't have any ext2 or ext3
file systems on the server.  If I am going to set up an external bitmap, I
am going to have to steal some space from one of the other file systems -
perhaps from the swap area (5G), the boot file system (reiserfs - 109G), or
the Windows XP filesystem (NTFS - 40G).  I need to be able to calculate how
much space to steal to fit the bitmap, and allow for later expansion.

> >  >If so, would ext2 probably be the best choice?
> >
> > That's what the man page says. I find it strange since if it's a file
> > the filesystem shouldn't matter. Neil?
> 
> The way that md writes to the bitmap file is not entirely portable
> across different filesystems.  As the man page say,  it is known to
> work for ext2 and ext3.  Either is a fine choice.

	I'm fine with shrinking one of the existing file systems and
creating a tiny partition just for the bitmap.


