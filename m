From: Scott Mcdermott <smcdermott@questra.com>
Subject: Re: Questions about VERY large software raid config
Date: Fri, 21 Feb 2003 10:56:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030221155602.GN21959@questra.com>
References: <8075D5C3061B9441944E137377645118012E65@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8075D5C3061B9441944E137377645118012E65@cinshrexc03.shermfin.com>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rechenberg, Andrew on Fri 21/02 10:42 -0500:
> Basically I'm going to do a bunch of RAID1 mirrors (56 drives), RAID)
> those in sets of 14 and then stripe those 4 into one big array.

I'm curious, why aren't you doing a RAID0 stripe of 28 RAID1s instead?
It sounds like you are doing a RAID0 stripe of 4 RAID0 stripes of 14
RAID1s.  Why the extra step, it can only slow you down???
