From: dave rientjes <rientjes@google.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Tue, 25 Jul 2006 10:41:32 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0607251039370.12479@chino.corp.google.com>
References: <44C5BA6F.3010404@steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C5BA6F.3010404@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Tue, 25 Jul 2006, Paul Clements wrote:

> @@ -1322,6 +1324,18 @@ static void bitmap_set_memory_bits(struc
>
>  }
> 
> +/* dirty the memory and file bits for bitmap chunks "s" to "e" */
> +void bitmap_dirty_bits(struct bitmap *bitmap, unsigned long s, unsigned long 
e)
> +{
> +       unsigned long chunk;
> +
> +       for (chunk = s; chunk <= e; chunk++) {
> +               sector_t sec = chunk << CHUNK_BLOCK_SHIFT(bitmap);
> +               bitmap_set_memory_bits(bitmap, sec, 1);
> +               bitmap_file_set_bit(bitmap, sec);
> +       }
> +}
> +

Why not

{
 	for (; s <= e; s++) {
 		sector_t sec = s << CHUNK_BLOCK_SHIFT(bitmap);
 		...
 	}
}

 		David
