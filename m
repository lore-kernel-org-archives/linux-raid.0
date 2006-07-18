From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Tue, 18 Jul 2006 12:07:54 +0200
Message-ID: <bb145bd20607180307i2914eef0q52446edd694f45df@mail.gmail.com>
References: <20060702224549.GD12733@percy.comedia.it>
	 <17576.21342.685662.432117@cse.unsw.edu.au>
	 <44AA42F6.8070307@tls.msk.ru> <e8dmd5$kek$1@sea.gmane.org>
	 <17596.28516.152402.395214@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.28516.152402.395214@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I think I'm leaning towards auto-creating names if they look like
> standard names (or are listed in mdadm.conf?), but required
> auto=whatever to create anything else.

The auto= option has the disadvantage that it is different for
partitionable and regular arrays -- is there no way to detect from the
array if it is supposed to be partitionable or not?

As it is scripts are better off creating the node with correct
major/minor and assembling without auto=.

Regards,

C.
