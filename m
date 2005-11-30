From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: [PATCH md 013 of 18] Improve handing of read errors with raid6
Date: Wed, 30 Nov 2005 20:33:56 -0200
Message-ID: <17294.10452.328325.214081@fisica.ufpr.br>
References: <20051128102824.14498.patches@notabene>
	<1051127234043.14889@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051127234043.14889@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown (neilb@suse.de) wrote on 28 November 2005 10:40:
 >This is a simple port of match functionality across from raid5.
 >If we get a read error, we don't kick the drive straight away, but
 >try to over-write with good data first.

Does it really mean that this funcionality is already available for
raid5??? That would be great news.
