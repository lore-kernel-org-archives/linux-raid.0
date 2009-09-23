From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 11:13:28 +0200
Message-ID: <20090923091328.GA19193@rap.rap.dk>
References: <20090922200912.GA28999@cthulhu.home.robinhill.me.uk> <151287.16979.qm@web38804.mail.mud.yahoo.com> <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090923075710.GA9409@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 23, 2009 at 08:57:10AM +0100, Robin Hill wrote:
> On Tue Sep 22, 2009 at 02:56:08PM -0700, adfas asd wrote:
> 
> > Thanks Robin.
> > 
> > --- On Tue, 9/22/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > > The BIOS boots from a single drive, and won't boot from RAID10, so
> > > presumably you already have a non-RAID (or RAID-1) boot partition.
> > 
> > I have my only two drives set up as RAID10offset2 (WD 2TB each), and
> > it boots just fine for some reason.
> > 
> Yes, with a 2-drive RAID10o2 layout, one of the drives contains all
> blocks in normal order, the other doesn't (see
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10)
> so if the one drive fails then your system will be non-bootable.  A
> RAID10n2 or RAID1 (the layout's the same) would be a better choice.

There is a setup described at 

http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk

You can substitute raid10,o2 for raid10,f2 for the root partitions etc.

Anyway, raid10,f2 should be faster than raid10,o2, for at least reads,
while for writes it is about the same performance given that you employ
a file system.

Best regards
keld
