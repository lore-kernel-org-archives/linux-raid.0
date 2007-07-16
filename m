From: Bernd Schubert <bs@q-leap.de>
Subject: Re: 3ware 9650 tips
Date: Mon, 16 Jul 2007 14:39:22 +0200
Message-ID: <200707161439.23159.bs@q-leap.de>
References: <alpine.LRH.0.999.0707131356520.25773@chaos.egr.duke.edu> <20070716024115.GJ12413810@sgi.com> <20070716122225.GB31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070716122225.GB31489@sgi.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Collette <jon@etelos.com>, Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Monday 16 July 2007 14:22:25 David Chinner wrote:
> You can see from the ext3 graph that it comes to a screeching halt
> every 5s (probably when pdflush runs) and at all other times the
> seek rate is >10,000 seeks/s. That's pretty bad for a brand new,
> empty filesystem and the only way it is sustained is the fact that
> the disks have their write caches turned on. ext4 will probably show
> better results, but I haven't got any of the tools installed to be
> able to test it....

I recently did some filesystem throuput tests, you may find it here

http://www.pci.uni-heidelberg.de/tc/usr/bernd/downloads/lustre/performance/

ldiskfs is ext3+extents+mballoc+some-smaller-patches, so is almost ext4 
(delayed allocation is still missing, but the clusterfs/lustre people didn't 
port it and I'm afraid of hard to detect filesystem corruptions if I include 
it myself).

Write performance is still slower than with xfs and I'm really considering to 
try to use xfs in lustre.

Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
