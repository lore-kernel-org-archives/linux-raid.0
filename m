From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Why can't I stop these arrays?
Date: Mon, 23 Jun 2008 01:55:47 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0806230154370.31819@uplift.swm.pp.se>
References: <20080622223517.GD5474@nexus.edgeofthenet.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080622223517.GD5474@nexus.edgeofthenet.org>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 22 Jun 2008, Richard Michael wrote:

> they don't even have filesystems on them.  As far as I can tell, nothing 
> on the system is using them.

Have you used the "lsof" utility to see what process might be accessing 
the md devices? That's where I start when I run into the problem you 
described (not knowing what is locking what I want to unmount or stop).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
