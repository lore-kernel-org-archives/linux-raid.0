From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 013 of 18] Improve handing of read errors with raid6
Date: Thu, 1 Dec 2005 13:54:33 +1100
Message-ID: <17294.26089.351521.192306@cse.unsw.edu.au>
References: <20051128102824.14498.patches@notabene>
	<1051127234043.14889@suse.de>
	<17294.10452.328325.214081@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Carlos Carvalho on Wednesday November 30
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 30, carlos@fisica.ufpr.br wrote:
> NeilBrown (neilb@suse.de) wrote on 28 November 2005 10:40:
>  >This is a simple port of match functionality across from raid5.
>  >If we get a read error, we don't kick the drive straight away, but
>  >try to over-write with good data first.
> 
> Does it really mean that this funcionality is already available for
> raid5??? That would be great news.

Yes.  It has been in -mm for a while, and will be in 2.6.15.  The
raid1/raid6/raid10 versions will have to wait for 2.6.16.

I'll probably do a little 'md Release notes' announcement when 2.6.15
comes out if I remember.

NeilBrown
