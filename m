From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID Issues - RAID10 working but with errors
Date: Thu, 2 Apr 2020 10:49:06 +0200
Message-ID: <832cb2b3-e9d3-e1a6-4ba5-f1f1b5d22b97@thelounge.net>
References: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 02.04.20 um 04:28 schrieb Adam Goryachev:
> Is there a method to determine if this is a HDD error (ie, 2 drives that
> have errors) or a cabling issue (with just these two drives) or some
> strange driver/motherboard issue?

just try by start with the cheapest option: cables

when nothing changes switch where they disks are connected and you will
find out it's the motherboard when suddenly one drive that was completly
fine before has the same issue

> I notice in the output below MD is showing a number of bad blocks on the
> drives, and logs suggest that the drives have run out of "spare" space
> to re-allocate these to.
from the moment on some software stack is telling you about bad blocks
on drives run fast and replace fast
