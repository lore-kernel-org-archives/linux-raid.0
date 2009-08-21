From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 12:22:43 -0500
Message-ID: <20090821172242.GB18915@sewage>
References: <20090820163522.GA29215@sewage> <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B2E9A6F9E25@SE-EX008.groupinfra.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Henry, Andrew" <andrew.henry@logica.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Aug 21, 2009 at 08:42:09AM +0200, Henry, Andrew wrote:
> I had a similar issue, as I wanted to take full advantage of
> parking heads but they kept coming alive again.  I was putting
> them to sleep with hdparm.
> 
> I gave up at the end, but thought I had read that it was likely
> syslog or other internals that were polling the disc too
> frequently.  Sorry Im a bit vague on the details.
> 
> If this was the case (I didn't really investigate) then I thought,
> stuff it, because I wanted syslog to keep doing it's thing.

Good to know.  I should have mentioned, however, that my RAID5
drives are just for data storage.  The OS (and therefore syslog and
friends) is actually on a compact flash card (using one of those
compact flash to IDE converters).

Thanks,
Matt

