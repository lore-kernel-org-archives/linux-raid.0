From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] raid1: abort resync if there are no spare drives
Date: Wed, 3 Mar 2004 11:21:01 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16453.9453.352217.737577@notabene.cse.unsw.edu.au>
References: <20040223024124.GA1590@psilocybus>
	<16441.33071.218049.163976@notabene.cse.unsw.edu.au>
	<403A30F9.D54AAC68@SteelEye.com>
	<403D15FE.CAACDC4A@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Wednesday February 25
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 25, Paul.Clements@SteelEye.com wrote:
> The attached patch makes sure that resync/recovery get aborted (and
> status recorded correctly) when there are no spare drives left (due to
> the failure of a spare during a resync). Previously, if a spare failed
> during a resync, the resync would continue until completed (and would
> appear to be successful). 

Hi,
 could you clarify exactly what the problem is.

 As far as I can see (without looking very deeply) the only problem is
 that the resync process continues on when there is no point doing so,
 thus wasting time.
 At the end of the process, any devices that failed should still be
 marked failed and so the array will be insync, but might be degraded
 - but there is no risk to data.

Am I missing something?

(I"m not saying I don't like the patch - it looks like a good idea - I
just want to be sure I understand it).

NeilBrown
