From: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: Where is the performance bottleneck?
Date: Tue, 30 Aug 2005 09:09:06 +1000
Message-ID: <17171.38290.829050.71419@wombat.chubb.wattle.id.au>
References: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751337AbVH2XJS@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0508291811480.24072@diagnostix.dwd.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Holger" == Holger Kiehl <Holger.Kiehl@dwd.de> writes:

Holger> Hello I have a system with the following setup:

	(4-way CPUs, 8 spindles on two controllers)

Try using XFS.

See http://scalability.gelato.org/DiskScalability_2fResults --- ext3
is single threaded and tends not to get the full benefit of either the
multiple spindles nor the multiple processors.

--
Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
The technical we do immediately,  the political takes *forever*
