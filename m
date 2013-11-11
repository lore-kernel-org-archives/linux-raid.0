From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Mon, 11 Nov 2013 09:55:29 -0600
Message-ID: <l5qulc$kaa$1@ger.gmane.org>
References: <5280870E.6080703@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5280870E.6080703@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/11/2013 01:28 AM, Michael Tokarev wrote:
> The question is: what's missing currently to prevent kicking
> drives from md arrays at all?  And I really mean preventing
> _both_ first failed drive (before start of resync) and second
> failed drive?

I'm becoming increasingly convinced that hot-spares are a bad idea,
particularly when you're one failure away from data loss.  (I.e. I might
be willing to auto-add a hot-spare after the initial failure in a RAID-6
array, but not after a second failure.)

I much prefer to do a manual recovery, after using a badblocks read-only
test to check all of the component devices for bad sectors.  (I also
build my MD arrays out of partitions rather than entire drives to make
this process more manageable.)

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
           Sent from the cloud -- where it's already tomorrow
========================================================================

