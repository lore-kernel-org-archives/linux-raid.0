From: Luca Berra <bluca@comedia.it>
Subject: Re: possible to use 1 drive as hot failover for 2 raid1's?
Date: Tue, 07 Oct 2003 17:56:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F82E242.60700@comedia.it>
References: <Pine.LNX.4.44.0310061625260.12382-100000@sasami.anime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310061625260.12382-100000@sasami.anime.net>
To: Dan Hollis <goemon@anime.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Hollis wrote:

> We have 5 drives, 2 for raid1-md0 and 2 for raid1-md1. they are all the 
> exact same model and partitioned exactly the same. we also have a 5th 
> drive we want to use as hot-failover.
> 
> is it possible to use the single drive as hot-failover for both md0 and 
> md1?
> 

you can do this with mdadm
http://www.cse.unsw.edu.au/~neilb/source/mdadm/

