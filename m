From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3ware 7500 performance, was: experiences with 3Ware 6400 3W-6400?
Date: Sat, 28 Jun 2003 15:42:58 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306281539510.24992-100000@uplift.swm.pp.se>
References: <6661311060.20030628170015@mail.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6661311060.20030628170015@mail.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 28 Jun 2003, Alex Verbitsky wrote:

> What do you mean by this? I did not notice anything like this, though i
> use it for sequental i/o mainly. if your i/o is highly random, then
> 3ware acceleration (R5 fusion) is not working and you should receive
> something like 5-10 MB/s.

Which is exactly what we all get in real-life file server environment when
using onboard RAID5 without a lot of onboard cache (though I have seen the
same behaviour even on SX6000 with 128 meg ram). Filesystem read is
phenomenally fast (I have seen 150 meg+ off of 8 disk arrays) but write is 
very slow (5-10 meg/s).  Sequential write is also fast, but that never 
happens in a fileserver environment.

Since I use my raid5 mainly for long time cheap storage I don't have a big 
problem with all this, stability and ease of management is what I'm 
looking for, so I choose hardware raid5 on 3w7500.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

