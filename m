From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Mapping physical disk block to logical block to selectively repair w/o forcing rescan
Date: Tue, 15 Apr 2008 17:37:28 -0700
Message-ID: <e9c3a7c20804151737k44b09572x484c7c41ff90e09d@mail.gmail.com>
References: <A49AB75A717185448F69082E969E536B03C2647E@34093-EVS1C2.exchange.rackspace.com>
	 <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20804151735n6793339dl764c0d57aedabc57@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  >
>  >  Any advice, comments, code will be appreciated.
>  >
>
>  raid5_compute_sector() in drivers/md/raid5.c maps the logical RAID
>  block to the physical block.  Is that what you are looking for?
>

...and compute_blocknr() goes the other way.

--
Dan
