From: Alexander Schreiber <als@thangorodrim.de>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 14:29:21 +0100
Message-ID: <20110129132921.GA15784@mordor.angband.thangorodrim.de>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <-8313021219290464576@unknownmsgid>
 <AANLkTin9L4u_vKJSpvVrnH7-QX_TbhqJ3drw7BKn2HDy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTin9L4u_vKJSpvVrnH7-QX_TbhqJ3drw7BKn2HDy@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 29, 2011 at 04:42:16AM -0200, Roberto Spadim wrote:
> is it better than nbd+mdadm?

Definitely. We are using drbd replicated disks on a _lot_ of machines,
with all kinds of outside events: disk failures, network failures,
machine failures of various interesting variants. Despite this kind of
pounding, drbd turned out to be very robust, with data loss happening
very rarely (well, with some combined failures you are just plain
screwed - that's why one has backups).

Kind regards,
           Alex.
-- 
"Opportunity is missed by most people because it is dressed in overalls and
 looks like work."                                      -- Thomas A. Edison
