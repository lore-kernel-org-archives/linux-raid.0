From: Derek Vadala <derek@cynicism.com>
Subject: Re: ANNOUNCE: mdadm-1.0.9 - prelease for 1.1.0
Date: Thu, 20 Feb 2003 12:55:23 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030220175523.30AF33B809@jaded.cynicism.com>
References: <15945.38175.58593.681394@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15945.38175.58593.681394@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 Feb 2003, Neil Brown wrote:

>     -   If the config file is called 'partitions' then it will be treated
>         as though it contained exactly 'device partitions' so e.g.
> 	  mdadm -Ebsc partitions
> 	will fill all raid partitions easily.

So the difference between this and mdadm -Dbs is that it generates config
entries for arrays that are online, but -Ebcs partitions gets a list of
all the block devices from /proc/partitions and generates array lines
based on those.

How come -Dbs lists only num-device, and UUID while -Ebsc lists both of
those as well as the devices list?

This -Ebsc partitions is a nice feature by the way.

-- 
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

