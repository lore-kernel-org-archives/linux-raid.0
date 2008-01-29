From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Tue, 29 Jan 2008 12:16:15 -0200
Message-ID: <18335.13615.134324.887637@fisica.ufpr.br>
References: <4797430E.2020603@dionic.net>
	<18327.31959.286239.480961@fisica.ufpr.br>
	<4798F577.20007@dionic.net>
	<479E1106.5000106@dionic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E1106.5000106@dionic.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Southerwood (ts@dionic.net) wrote on 28 January 2008 17:29:
 >Subtitle: Patch to mainline yet?
 >
 >Hi
 >
 >I don't see evidence of Neil's patch in 2.6.24, so I applied it by hand
 >on my server.

I applied all 4 pending patches to .24. It's been better than .22 and
.23... Unfortunately the bitmap and rai1 patch don't go in .22.16.
