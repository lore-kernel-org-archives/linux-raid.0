From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Regarding RAID0 Code
Date: Mon, 3 Jan 2005 16:49:34 +1100
Message-ID: <16856.56558.323822.218401@cse.unsw.edu.au>
References: <20050101081509.4238.qmail@web60404.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Poonam Dalya on Saturday January 1
Sender: linux-raid-owner@vger.kernel.org
To: poonamsbox@yahoo.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday January 1, poonamsbox@yahoo.com wrote:
> Respected Sir,
>  
>             I am a student from India. I am studying the RAID 0 code
>             in the linux kernel 2.4.20. I got some problems in
>             understanding the code, especially in the
>             raid0_make_request function. I didnt understand the
>             following statements.. like why the anding is done, and
>             what is sect_in_chunk. Please if you could tell me the
>             details, it would be a very great help for me. Please
>             sir, hoping for some help. 
>  
> 258         sect_in_chunk = bh->b_rsector & ((chunk_size<<1) -1);
> 259         chunk = (block - zone->zone_offset) / (zone->nb_dev << chunksize_bits);
> 260         tmp_dev = zone->dev[(block >> chunksize_bits) % zone->nb_dev];
> 261         rsect = (((chunk << chunksize_bits) + zone->dev_offset)<<1)
> 262                 + sect_in_chunk;

"sect_in_chunk" is the number of the target sector within it's chunk.
i.e. the remainder when the target sector is divided by the chunk
size.

If it still doesn't make sense, try writing the code for mapping an
array sector number to a (device number + device sector number).  Then
ask specifically about differences.

NeilBrown

> 
>                Thanking you in anticipation.
>  
> With Regards,
> Poonam Dalya,
> PICT,Pune,
> INDIA.
> 
