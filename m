From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Tue, 10 Feb 2004 11:57:39 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40290D83.586CF312@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com>
		<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
		<4027E342.D02202F1@SteelEye.com> <16424.8182.876520.280031@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

Neil Brown wrote:
 
> > > - A question - can the bitmap be "rescaled" online, or only offline?
> > >   (not that I particularly want on-line rescaling) How is it achieved?
> >
> > The bitmap file can be rescaled offline by simply expanding or
> > collapsing the bits as necessary, and then writing the enlarged or
> > shrunken bitmap file. When the array is started (with a new bitmap chunk
> > size), everything will work correctly. (The bitmap file can also be
> > truncated, in which case the driver will assume all the bits to be dirty
> > and perform a full resync).
> >
> 
> It would seem to make sense to store the "chunk size" in the bitmap
> file.
> In fact, if the bitmap file had a small header containing:
>     magic number
>     array uuid
>     event count
>     bitmap chunk size
> Then you could rescale the bitmap without touching the superblock and
> would at the same time solve the problem with possibly getting an
> out-of-date bitmap.

That sounds good, as it would lend some more foolproofing to the bitmap
file operations. The only problem being that we wouldn't be able to
support bitmaps without backing files (in-memory only bitmaps). I guess
if we don't think that's a useful feature we could do this. 

We could also add this bitmap file superblock as a follow-on patch. The
code that reads in the bitmap file would simply look for the magic
string in the superblock to determine if the bitmap file is a flat file
(old style) or contains a superblock (new style).

--
Paul
