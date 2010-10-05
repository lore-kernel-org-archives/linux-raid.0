From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Restoring data from linear raid
Date: Tue, 5 Oct 2010 10:33:23 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1010051026530.29868@uplift.swm.pp.se>
References: <AANLkTik6gET5PXskntGGNC4xfrga8UHxU7pcJXwArYgS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik6gET5PXskntGGNC4xfrga8UHxU7pcJXwArYgS@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Shevaev <pacha.shevaev@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Oct 2010, Pavel Shevaev wrote:

> I really want to restore _anything_ from the linear raid partition of
> the working drive, is it possible at all?

It depends on the filesystem. You now have a huge gap in the block data 
and I have successfully extracted some files from an ext2 fs in this case, 
but don't know much about the others.

I'd recommend to ddrescue the defective drive to a new drive and get as 
much data off of it as possible.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
