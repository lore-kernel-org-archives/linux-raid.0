From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Tue, 22 Sep 2009 14:56:08 -0700 (PDT)
Message-ID: <151287.16979.qm@web38804.mail.mud.yahoo.com>
References: <20090922200912.GA28999@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090922200912.GA28999@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Robin.

--- On Tue, 9/22/09, Robin Hill <robin@robinhill.me.uk> wrote:
> The BIOS boots from a single drive, and won't boot from
> RAID10, so
> presumably you already have a non-RAID (or RAID-1) boot
> partition.

I have my only two drives set up as RAID10offset2 (WD 2TB each), and it boots just fine for some reason.


> > > What if I use the mobo's e-SATA port to add 5
> external
> > > drives locally. This would require a port
> multiplier. I
> > > presume it would not be bootable, since a port
> multiplier
> > > needs OS support? Or would something go in
> initrd.img? 
> > > Or would I need an individual boot drive to get
> things up?
> > >  
> Depends on exactly how the BIOS sees is - some seem to see
> a single
> drive off the multiplier, so can boot off that one, whereas
> others won't
> see anything.  The initrd question is immaterial, as
> this is only read
> after the BIOS has called the boot loader, but certainly
> you could load
> any necessary drivers at that point.

It's an Asus P5N7A-VM mobo, and of course Asus doesn't know the answer to this question.  I have in mind the Addonics port "software" multiplier, which is a pure hardware multiplexer.  (AD5SARPM-E with eSATA & Sii3726 chip)

I guess the answer is to just buy and try it.  Reluctant to though, owing to the expense.  I am surprised no one else has tried this.

 
> I'm not sure offset is really noticeably faster than far
> for writes.
> Commercial flagging shouldn't be writing to the recordings
> drive though
> - it's just inserting database metadata.  If your
> MythTV database is on
> the same array/drives then you'll certainly get a big gain
> from moving
> it to a separate disk.

Commercial flagging is writing like hell to the array, according to iotop.  I don't know how else to assess what's going on.  The drives are constantly hammering, and my Myth menu moves get very slow during flagging, even with the latest 2TB disk drives and RAID10.




      
