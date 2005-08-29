From: Al Boldi <a1426z@gawab.com>
Subject: Re: Where is the performance bottleneck?
Date: Mon, 29 Aug 2005 23:10:39 +0300
Message-ID: <200508292310.39903.a1426z@gawab.com>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751501AbVH2UK7@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Holger Kiehl wrote:
> Why do I only get 247 MB/s for writting and 227 MB/s for reading (from the
> bonnie++ results) for a Raid0 over 8 disks? I was expecting to get nearly
> three times those numbers if you take the numbers from the individual
> disks.
>
> What limit am I hitting here?

You may be hitting a 2.6 kernel bug, which has something to do with 
readahead, ask Jens Axboe about it! (see "[git patches] IDE update" thread)
Sadly, 2.6.13 did not fix it either.

Did you try 2.4.31?

--
Al
