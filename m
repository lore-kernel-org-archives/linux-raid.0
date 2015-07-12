From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Resurrecting a Dirty RAID-5
Date: Sun, 12 Jul 2015 07:57:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507120756020.11810@uplift.swm.pp.se>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org> <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com>
Sender: linux-raid-owner@vger.kernel.org
To: jtroan@jt-sw.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 8 Jul 2015, jtroan@jt-sw.com wrote:

> I'm also thinking about adding a fourth drive and try to config it as a 
> hot-spare, giving me some extra margin for failure.

I would recommend you turn your raid5 into raid6 instead of having a 
raid5+spare. This can be done with a fairly simple command, without 
downtime.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
