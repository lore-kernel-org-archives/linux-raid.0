From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Wed, 23 Jan 2008 15:43:51 -0200
Message-ID: <18327.31959.286239.480961@fisica.ufpr.br>
References: <4797430E.2020603@dionic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4797430E.2020603@dionic.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Southerwood <ts@dionic.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Southerwood (ts@dionic.net) wrote on 23 January 2008 13:37:
 >Sorry if this breaks threaded mail readers, I only just subscribed to 
 >the list so don;t have the original post to reply to.
 >
 >I believe I'm having the same problem.
 >
 >Regarding XFS on a raid5 md array:
 >
 >Kernels 2.6.22-14 (Ubuntu Gutsy generic and server builds) *and* 
 >2.6.24-rc8 (pure build from virgin sources) compiled for amd64 arch.

This has been corrected already, install Neil's patches. It worked for
several people under high stress, including us.
