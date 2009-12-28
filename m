From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: why md/raid5 dont have bad block remap
Date: Mon, 28 Dec 2009 12:07:20 +0100 (CET)
Message-ID: <alpine.DEB.1.10.0912281204480.27231@uplift.swm.pp.se>
References: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jin zhencheng <zhenchengjin@gmail.com>
Cc: linux-raid@vger.kernel.org, zhenchengjin@163.com
List-Id: linux-raid.ids

On Mon, 28 Dec 2009, jin zhencheng wrote:

> hi ,
>
> I think it isn't  complicated for raid5 to add bad block remap.
>
> "bad block remap" is means that if  a bio is written error, we not
> fauty the disk, and try to write this bio  to other place which
> alloced  for bad block remap.
>
> i dont  know why MD/raid5 add this function ?

What is done is upon read error the parity is read and the block that had 
a read error is calculated and written, and then the unit in question has 
the responsibility of mapping the block/sector as faulty and write it 
someplace else.

Drives which has used up that space and thus can't remap should be 
replaced with a working drive, it's obviously faulty.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
