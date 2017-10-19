From: dfc <chernoff@astro.cornell.edu>
Subject: Re: USB chasis fails, fate of the software raid?
Date: Wed, 18 Oct 2017 20:06:18 -0400
Message-ID: <1508371578.2692.34.camel@astro.cornell.edu>
References: <1508353481.2692.9.camel@astro.cornell.edu>
         <17362074-5ca8-acc4-ab3b-0f5a41875416@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17362074-5ca8-acc4-ab3b-0f5a41875416@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2017-10-18 at 22:28 +0200, Rudy Zijlstra wrote:
> Hi David,
> 
> 

Hi Rudy,

> Op 18/10/2017 om 21:04 schreef dfc:
> > I have an Orico (3559SUSJ3) external 5 bay
> > hard disk drive enclosure attached via
> > USB to my desktop computer.
> 
> USB is indeed not the best choice.
> 
> > It holds 5 * 4 TB disks in raid5 and
> > has functioned for a couple of years.
> 
> <snip>
> > My main question is whether inserting
> > the 5 disks into another JBOD chasis
> > is likely to work?
> 
> Yes, this should work. With a little luck you would not even need to 
> force it, as with a component failure all disks should have lost 
> connection at the same time.
> The biggest risk is that the failure caused spikes before final
> death, 
> causing damage on the HDD. But without knowing the actual failure
> that 
> is pure conjecture.
> You could test each disk separately -- as long as you only read from 
> them. Only reading is to ensure that no changes are done that make
> later 

Thanks, I will try reading disks and then install in a new
chasis.

> re-build of the raid difficult.
> > In particular is
> > mdadm "smart enough" to find all
> > the components and/or do I need to do
> > something to help it along? In fact,
> > our IT person has suggested that the
> > data may well be lost.
> 
> Your IT person apparently either thinks the HW failure caused
> extensive 
> damage, or wants you to do something different, or... is not very 
> knowledgeable about this type of setup.
> 
> <snip>
> > Also, since I first used the JBOD with software
> > raid I came to realize that the usb connection
> > is not a good choice (though I have never had
> > problems). What sort of connection (at the low
> > price end of the market for HDD enclosures)
> > would be better? eSata or something else?
> 
> eSATA would work. But depends on the type of enclusure you can get.
> I 
> leave that to people based in USA, who know what is available there.
> 
> Cheers
> 
> Rudy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
