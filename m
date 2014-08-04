From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: On URE and RAID rebuild - again!
Date: Mon, 4 Aug 2014 09:02:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1408040858220.7929@uplift.swm.pp.se>
References: <53D8ACF0.1070202@assyoma.it> <alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se> <53D8ED99.90606@assyoma.it> <20140731073121.38cd1773@notabene.brown> <53D9ED48.9000307@assyoma.it> <1370eb7a35b628323646a86094a26912@assyoma.it>
 <20140803134834.7773b0ab@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140803134834.7773b0ab@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Gionatan Danti <g.danti@assyoma.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 3 Aug 2014, NeilBrown wrote:

> You are very unlikely to see UREs just be reading the drive over and over a
> again.  You easily do that for years and not get an error.  Or maybe you got
> one just then.

Also you might get an intermittent URE. I have had drives where the sector 
would be successfully be read after several attempts. Why the drive 
doesn't re-write the sector when it needs hundreds or thousands of 
attempts to read it, I don't know. I would very much like to talk to 
someone who really knows how these things works end-to-end, but I don't 
have access to anyone like that. Most of the information to be found 
publically is by people deducing behaviour from experience from the 
outside of this "black box".

>> 2) how UREs should be visible? Via error reporting through dmesg?
>
> If you want to see how the system responds when it hits a URE, you can use the
> hdparm command and the "--make-bad-sector" option.  There is also a
> "--repair-sector" option which will (hopefully) repair the sector when you
> are done.

Does this command do the same as with a real URE, ie will try until the 
timeout of the drive (which is what, 90 seconds on a consumer drive, 7 
seconds of an enterprise drive, right?).

If it fails immediately then it's not testing the same thing as a "real" 
URE. Might be good to know if one does testing that's supposed to emulate 
real failures.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
