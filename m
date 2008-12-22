From: Bin Guo <bguo@starentnetworks.com>
Subject: Re: md looping on recovery of raid1 array
Date: Mon, 22 Dec 2008 00:49:07 -0500
Message-ID: <20081222054907.GA18510@bguogx620.starentnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Ryan_MichaelS@emc.com
List-Id: linux-raid.ids

I tried the patch with minor changes for 2.6.18 kernel with injected
read error, and it works as expected: with injected error, adding
spare disk would fail with no more repeated retries; unset the injected
error, spare disk can be added and sync'ed fine.

Thanks,
-- 
Bin
