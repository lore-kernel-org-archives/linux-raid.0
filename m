From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 10:32:24 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E79DF08.85CE767@SteelEye.com>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org> <15993.2378.97234.342504@notabene.cse.unsw.edu.au> <20030320075133.ALLYOURBASEAREBELONGTOUS.B4264@bla.fasel.org> <15993.36889.254497.789214@notabene.cse.unsw.edu.au> <20030320122227.ALLYOURBASEAREBELONGTOUS.G4264@bla.fasel.org> <20030320133455.GA29878@willow.seitz.com> <20030320141907.ALLYOURBASEAREBELONGTOUS.K4264@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Wolfram Schlich <lists@schlich.org>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wolfram Schlich wrote:
> 
> * Ross Vandegrift <ross@willow.seitz.com> [2003-03-20 14:35]:
> > On Thu, Mar 20, 2003 at 01:22:27PM +0100, Wolfram Schlich wrote:
> > > I've put up the logfile of fsck at
> > > http://wolfram.schlich.org/tmp/fsck.log.1
> > > I have no idea whether this is an "uncomfortable large amount of
> > > damage", so would you mind having a look at it? :-) TIA!
> >
> > That's a pretty huge amount of damage.  If fsck is able to fix it
> > without trashing data, then it doesn't matter.  I missed how big your
> > array was, but if you have the resources to make an image of the raw
> > devices, I'd definately reccomend you do so:
> 
> Unfortunately the array is 4x120G. I just don't have that space
> anywhere else :-(( Anyway, do the *kinds* of errors show these are
> 'critical' ones?

Well, mostly looks like your free block and inode counts are wrong,
which I believe fsck can correct fairly accurately. However, as Ross
said, you have extensive corruption of your filesystem metadata, so the
data very well could be corrupted too, but fsck isn't going to tell you
about that...you'll just have to find out... :). If you can't make a
backup of the disks, I guess you just have to give it a shot, anyway,
right?

--
Paul
