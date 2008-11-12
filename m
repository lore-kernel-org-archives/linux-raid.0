From: "Ryan Wagoner" <rswagoner@gmail.com>
Subject: Re: OT: Tips for good hard drives for a home server
Date: Wed, 12 Nov 2008 09:19:20 -0500
Message-ID: <7d86ddb90811120619vca13676tb0192676ece0cb93@mail.gmail.com>
References: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ECBDC05781B3D48ABD520A01ABF2F9B299C974A5A@SE-EX008.groupinfra.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I used to buy Seagate drives for their 5 year warranty. However with
the capacities increasing like they are the 5 vs 3 years doesn't
really matter as much. Out of the 4 Seagate drives (2 160GB and 2
320GB) in my server that are 2.5 years old, the one is already showing
13 reallocated sectors. This might be due to non Barracuda drives
being certified for only 8 hours a day.

Recently I added have 5 Hitachi Deskstar TB drives in two different
machines which have been working great with mdadm in RAID 1 and 5. I
actually bought these after using 6 Hitachi Ultrastar TB drives in my
work's new Dell 2950 server. The server is setup in a 2 drive RAID 1
and a 4 drive RAID 5 for data archival and has worked flawlessly.

The Hitachi's are in the same price range as the Seagate Barracuda's
and offer 24/7 runtime and a 1 in 10^15 error rate vs 10^14 for
Seagate.

Any reason you are using RAID 0 for your server? Normally when I think
of a server reliability comes to mind and RAID 0 doesn't offer any.
I'm assumming you make nightly or weekly backups?

Ryan

On Wed, Nov 12, 2008 at 8:12 AM, Henry, Andrew <andrew.henry@logica.com> wrote:
>
