From: "John Stoffel" <john@stoffel.org>
Subject: Re: BBU + Writeback Controller suggestions please?
Date: Thu, 14 Jun 2012 15:22:20 -0400
Message-ID: <20442.14828.121252.69432@quad.stoffel.home>
References: <4FDA0D13.9030702@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FDA0D13.9030702@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ed> Hi, repeat of an older question I asked some months back.  Looking
Ed> to add BBU writeback "HBA" to run software raid over the top.  So
Ed> ideally I want either a raid controller which can pretend to be an
Ed> HBA with 4 individual drives each with writeback cache (and a
Ed> battery).  Or at a pinch I would accept a controller which can
Ed> offer 2 pairs of RAID-1 with writeback cache and I would run linux
Ed> raid-0 (or XFS storage groups) over the top - caveat that I would
Ed> very much desire that if the hardware controller fails I can pull
Ed> the individual raid-1 drives out and access them from a vanilla
Ed> motherboard controller?

Once you use a HW Raid controller like this, you're not going to be
able to just pull them out and use them with a vanilla controller.
Well... maybe if you just expose them as JBODs, but then I doubt there
will be any BBU of the devices, or caching, but that's very vendor
specific.

Why not just get a UPS for your server instead?  And monitor the UPS
and shutdown the server if there's a long (enough) outage to worry
about?  

Ed> The goal is to be able to safely enable writeback caching on a 4
Ed> drive RAID10 (or XFS over raid-1), but if the controller should
Ed> fail (or even just an urgent need to access the data from a second
Ed> machine) then I can access the arrays from another machine which
Ed> doesn't have such a controller. Operating system is a recent linux
Ed> 3 kernel

I think a UPS is a better bet.  

Ed> Can anyone comment on whether such a hardware card exists (seems
Ed> it's hard to get writeback caching on drives *and* have those
Ed> drives readable without the same controller present). Currently
Ed> eyeing up the Areca 1882 8 port unit - thoughts?

Instead of going down this route, just get a UPS and add more memory
to the system you can cache more of the filesystem in memory.  Then
you can also have multiple controllers so as to spread the load out.  

The increase in performance by adding BBU isn't going to be all that
much from my experience.  If anything, adding more spindles will give
you more performance.  But you're not clear about your workload,
whether it's large numbers of small files all over the place or fewer
by larger files?  Compile box?  Compute node?  Home directory server?  

John
