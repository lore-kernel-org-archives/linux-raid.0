From: Marc MERLIN <marc@merlins.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 28 Jan 2014 17:01:59 -0800
Message-ID: <20140129010159.GP28536@merlins.org>
References: <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <20140128165020.GL14998@merlins.org> <52E851C0.50202@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52E851C0.50202@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 28, 2014 at 06:56:32PM -0600, Stan Hoeppner wrote:
> On 1/28/2014 10:50 AM, Marc MERLIN wrote:
> > On Tue, Jan 28, 2014 at 01:46:28AM -0600, Stan Hoeppner wrote:
> >>> Today, I don't use PMPs anymore, except for some enclosures where it's easy
> >>> to just have one cable and where what you describe would need 5 sata cables
> >>> to the enclosure, would it not?
> >>
> >> No.  For external JBOD storage you go with an SAS expander unit instead
> >> of a PMP.  You have a single SFF 8088 cable to the host which carries 4
> >> SAS/SATA channels, up to 2.4 GB/s with 6G interfaces.
> >  
> > Yeah, I know about those, but I have 5 drives in my enclosures, so that's
> > one short :)
> 
> I think you misunderstood.  I was referring to a JBOD chassis with SAS
> expander, up to 32 drives, typically 12-24 drives with two host or two
> daisy chain ports.  Maybe an example would help here.
> 
> http://www.newegg.com/Product/Product.aspx?Item=N82E16816133047

Ah, yes, that.
So indeed in the price category of a PMP chassis with 5 drives ($150-ish), I
haven't found anything that isn't PMP or 5 sata cables.

> Yeah, something definitely not right.  Your RAID throughput is less than
> a single 7.2K SATA drive.  It's probably just something funky with that
> JBOD chassis.

That's also possible.
If/when I have time, I'll unplug things and plug the drives directly to the
card as well as try another MB.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
