From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Resync Every Sunday
Date: Sun, 1 Jul 2012 14:44:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011412270.27169@uplift.swm.pp.se>
References: <4FF0328B.5080103@abpni.co.uk> <4FF03CD9.9040409@abpni.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF03CD9.9040409@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Jul 2012, Jonathan Tripathy wrote:

> - Is it safe to disable these checks? Would monitoring the SMART status of 
> the disks serve as a good substitute?

Well, that's a decision you will have to make for yourself. The rationale 
behind it is to find latent read errors and correct them while you have 
parity already. Another term for this is "data scrubbing", you'll find 
quite a lot of discussion on that topic.

Personally, my view is that I make sure all my data are read at least once 
a month, I have experienced data loss historically because of lack of 
scrubbing.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
