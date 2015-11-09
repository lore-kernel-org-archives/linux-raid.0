From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: broken raid level 5 array caused by user error
Date: Mon, 9 Nov 2015 12:56:21 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Nov 2015, Mathias Mueller wrote:

> Please help me, I know I'm stupid and don't deserve it. I really hope, 
> there is a chance for reovering the array.

It's possible. There are numerous threads in the mailing list archives 
with people who have been in the same situation as you are in now. Without 
having a backup of the original superblocks, you're going to have to guess 
offsets. It might make sense to investigate what the defaults were for the 
mdadm you originally created the array with.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
