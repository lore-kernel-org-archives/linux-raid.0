From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 03:42:13 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402240339180.15054@uplift.swm.pp.se>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530AA09B.3090708@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Feb 2014, Brad Campbell wrote:

> The only reason I've ever seen this personally was when the pending 
> sectors were on non-data parts of the drive, like some of the space 
> around the superblock. Have you verified that these issues are really on 
> sectors in the data area? SMART should tell you the LBA of the first 
> error in a read test.

I even received UNC errors in the log when doing "repair" but the sector 
still wasn't re-written. So yes, they were on data part.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
