From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 15 Feb 2013 10:57:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302151055500.32644@uplift.swm.pp.se>
References: <20130214213908.282850@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214213908.282850@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Feb 2013, Dragon wrote:

> I heart that -force could be result in more problems - right? i do asswell:

Compared to the trouble people get into when getting --create 
--assume-clean and getting it wrong, I'd say --force is *nothing*.

--force needs drives that have similar event count, if they're too far 
apart (one drive for instance), then that specific drive shouldn't be 
used when assembling.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
