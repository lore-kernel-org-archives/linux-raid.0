From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Raid5 bitmap - Bug in bitmap_startwrite()
Date: Fri, 04 Aug 2006 10:20:49 -0400
Message-ID: <44D357C1.4090006@steeleye.com>
References: <fd8d0180608040205i5db2453flaf797ae506f823a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180608040205i5db2453flaf797ae506f823a6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Francois Barre wrote:

> Final question, I do not fully understand the bitmap_get_counter()
> function, especially comparing the 'hijacked' version (lines
> 1126-11127) :
>  return &((bitmap_counter_t *) &bitmap->bp[page].map)[hi];
> 
> and the 'normal' version (lines 1131-1132)
>   return (bitmap_counter_t *) &(bitmap->bp[page].map[pageoff]);
> 
> The hijacked version uses a 16-bit bitmap_counter_t*
> 'bitmap->bp[page].map' table with the hi index, whereas the normal
> uses a 8-bit char* 'bitmap->bp[page].map' table with the pageoff
> index.
> 
> This may be the 'hijacked' logic, but I'm a little puzzled here.

Yes. When we fail to allocate a page for the map (which should be rare), 
we, instead of failing the whole operation, just use the pointer to page 
, so we're basically using 4 bytes (the page pointer itself) instead of 
4K (the page) for that part of the bitmap. So each bit represents more 
data (1000x more in the case of x86).

--
Paul
