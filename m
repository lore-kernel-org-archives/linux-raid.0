From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Debian jessie - RAID 6 reshape - making no progress after >48
 hours
Date: Thu, 15 Oct 2015 09:09:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1510150906280.8750@uplift.swm.pp.se>
References: <20151014181019.6f7f9d0a@topdeck.tinsleyviaduct.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151014181019.6f7f9d0a@topdeck.tinsleyviaduct.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Reynolds <phil@tinsleyviaduct.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 14 Oct 2015, Phil Reynolds wrote:

> What can I safely do to move this along?

Please check the mailing list archives from the past months, you are not 
alone in having this problem. Do not reboot your machine or stop the 
array unless you absolutely need to, it might be possible to just issue 
--continue to the array.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
