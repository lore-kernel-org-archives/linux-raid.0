From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] raid10 ... (was: Re: ANNOUNCE: mdadm 1.7.0)
Date: Sat, 14 Aug 2004 11:51:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1092477101.3576.3.camel@zezette>
References: <16665.33913.505058.370245@cse.unsw.edu.au>
	 <20040811155507.307d91d0.pegasus@nerv.eu.org>
	 <16666.42485.178856.530123@cse.unsw.edu.au>
	 <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That is what you get from a LVM2 setting with 1 VG containing all your
disks and mirrored LVs.

I didn't check lately, but PE allocators certainly need to be more
intelligent with regard to not allowing mirror members on the same spin.

regards,
cvaroqui

> Imagine having a pool of drives, where chunks of data are distributed evenly
> across all drives in a redundant manner. If one drive dies, the chunks that
> are not redundant anymore get their copies on the remaining drives, provided
> that there's enough space left; if one or more drives are added to the
> array, new chunks are written there until the balance is reached again.
> 
> Disk space could be the first key for balancing across the drives, with
> transfer rate or seek time maybe added later. Maybe the pool could even
> adapt dinamically to the i/o patterns ... 
> 
> Am i dreaming (it's well over 4am here :) ? Or is something like this
> possible? Maybe not with a md personality, but by some daemon that would be
> taking care of a dm map?
> 

