From: Dominik Kubla <dominik.kubla@uni-mainz.de>
Subject: Re: Bug in multipath code (Linux 2.6.x) ?
Date: Sat, 10 Apr 2004 10:11:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404101011.58547.dominik.kubla@uni-mainz.de>
References: <B7A4A15090CB1847A60B569AC92FB9B352D24A@EXSTORE2.zdv.uni-mainz.de> <16500.33435.140991.667064@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16500.33435.140991.667064@cse.unsw.edu.au>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Dominik Kubla <kubla@uni-mainz.de>, linux-raid@vger.kernel.org, khoddam@netz.klinik.uni-mainz.de
List-Id: linux-raid.ids

On Thursday 08 April 2004 00:37, Neil Brown wrote:

> It wouldn't surprise me if there was a bug in the multipath code.
> I have no hardware to test it on and little interest in it.  I'm happy
> to fix obvious bugs and I try not to break it with other changes in
> md, but beyond that I just leave it alone.

Understandable. Maybe the Linux SAN-Alliance should sponsor you a couple of 
HBAs and a JBOD... ;-)

> I can do a simple test using two loopback devices on the same file as
> the two paths and that seems to work OK, so there is probably some
> interesting interaction with your particular hardware and it's driver.

Yes, that could get messy: FC-HBA <-> SCSI layer <-> MD driver

> So, if you can get good error messages and try to figure out what is
> actually happening, then I'm happy to look at fixing it, but without
> lots of details, there isn't much I can do.

I'll get you the correct error messages next week and i will try to work my 
way through the multipath code to understand what it's doing. Unfortunately 
it some years since i did serious work on the kernel internals, so i will 
most likely need to get a feel of what's changed.

Regards,
  Dominik Kubla
