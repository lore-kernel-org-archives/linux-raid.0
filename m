From: Jeff Morrow <jmorrow@jmorrow.org>
Subject: Re: Missing capacity in a RAID 5 array?
Date: Thu, 06 May 2004 10:10:13 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <409A7175.90307@jmorrow.org>
References: <Pine.LNX.4.44.0405060846050.6890-100000@uplift.swm.pp.se>
Reply-To: jmorrow@alum.mit.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0405060846050.6890-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Did you grow the filesystem after you grew the raid device? If you used 
> ext2s you should look at resize2fs.

Yep, that did it.  Many thanks for the quick responses!

Jeff


