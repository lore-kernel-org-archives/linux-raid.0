From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [PATCH] raid1: abort resync if there are no spare drives
Date: Tue, 02 Mar 2004 21:47:09 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4045472D.1F7964B3@SteelEye.com>
References: <20040223024124.GA1590@psilocybus>
		<16441.33071.218049.163976@notabene.cse.unsw.edu.au>
		<403A30F9.D54AAC68@SteelEye.com>
		<403D15FE.CAACDC4A@SteelEye.com> <16453.9453.352217.737577@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
 
>  As far as I can see (without looking very deeply) the only problem is
>  that the resync process continues on when there is no point doing so,
>  thus wasting time.

Yes, that's right. The pointless continuance of the resync is the
problem. The bad device does get marked as "failed", so there is no
problem with that.

--
Paul
