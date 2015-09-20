From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Failed Raid6 Array.....want some guidance before attempting
 restart
Date: Sun, 20 Sep 2015 07:34:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509200731460.8750@uplift.swm.pp.se>
References: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GGkLcN5RM7yq=D5NQ-DOBRf_+EwVsucoptfaiJPdU_nDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Sep 2015, Another Sillyname wrote:

> I don't just want to try a forced assemble until someone casts their eye 
> over this (and anything else wanted) and lets me know the best way to 
> proceed.....

The event counts are off by just a little bit, so if I were in your 
position I would stop the array and then --assemble --force with all the 
devices. If this doesn't work (because some of them are marked as failed), 
I would compile latest mdadm version from the git repository, and then try 
--assemble --force with that mdadm version instead.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
