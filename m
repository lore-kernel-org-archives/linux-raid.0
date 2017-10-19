From: dfc <chernoff@astro.cornell.edu>
Subject: Re: USB chasis fails, fate of the software raid?
Date: Thu, 19 Oct 2017 13:04:14 -0400
Message-ID: <1508432654.2579.5.camel@astro.cornell.edu>
References: <1508353481.2692.9.camel@astro.cornell.edu>
         <17362074-5ca8-acc4-ab3b-0f5a41875416@grumpydevil.homelinux.org>
         <1508371578.2692.34.camel@astro.cornell.edu>
         <9158b8e4-5b1a-7e06-e19e-a30bcedba334@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9158b8e4-5b1a-7e06-e19e-a30bcedba334@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil, Thanks for your comments below.

On Wed, 2017-10-18 at 20:44 -0400, Phil Turmel wrote:
> On 10/18/2017 08:06 PM, dfc wrote:
> > On Wed, 2017-10-18 at 22:28 +0200, Rudy Zijlstra wrote:
> > > USB is indeed not the best choice.
> 
> Rudy, you master of understatement!
> 
> > > > My main question is whether inserting the 5 disks into another 
> > > > JBOD chasis is likely to work?
> > > 
> > > Yes, this should work. With a little luck you would not even
> > > need 
> > > to force it, as with a component failure all disks should have
> > > lost connection at the same time.
> 
> I would be shocked if these disk *won't* assemble.  Assembly might
> need
> --force if any writes were in flight, but I doubt it.
> 
> > > You could test each disk separately -- as long as you only read 
> > > from them. Only reading is to ensure that no changes are done
> > > that 
> > > make later
> > 
> > Thanks, I will try reading disks and then install in a new chasis.
> 
> Just put them in a chassis and try to assemble.  If it succeeds, you
> are
> done.  If assembly fails, report what mdadm had to say.

Will do

> 
> > > re-build of the raid difficult.
> > > > In particular is mdadm "smart enough" to find all the
> > > > components 
> > > > and/or do I need to do something to help it along? In fact,
> > > > our 
> > > > IT person has suggested that the data may well be lost.
> > > 
> > > Your IT person apparently either thinks the HW failure caused 
> > > extensive damage, or wants you to do something different, or...
> > > is 
> > > not very knowledgeable about this type of setup.
> 
> Yeah, it does sound like somebody is out of their depth.
> 
> > > > Also, since I first used the JBOD with software raid I came to 
> > > > realize that the usb connection is not a good choice (though I 
> > > > have never had problems). What sort of connection (at the low 
> > > > price end of the market for HDD enclosures) would be better? 
> > > > eSata or something else?
> > > 
> > > eSATA would work. But depends on the type of enclusure you can
> > > get.
> > > I leave that to people based in USA, who know what is available
> > > there.
> 
> eSATA with a port multiplier should be fine.  It's spend a bit more
> for
> a JBOD with a SAS port and a suitable PCIe adapter.

Thank you, I will hunt for JBOD+SAS.
I need 5 or perhaps 6 disks in the array and am
still searching for a suitable unit.

David

> 
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
