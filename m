From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH/BUG] mdadm: write behind value does not have endian conversion
Date: Fri, 06 Oct 2006 15:03:42 -0400
Message-ID: <4526A88E.9000005@steeleye.com>
References: <45269835.2020801@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45269835.2020801@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:

> --- mdadm-2.5.1/bitmap.c.orig	Fri Oct  6 13:40:35 2006
> +++ mdadm-2.5.1/bitmap.c	Fri Oct  6 13:40:53 2006
> @@ -33,6 +33,7 @@ inline void sb_le_to_cpu(bitmap_super_t 
>  	sb->chunksize = __le32_to_cpu(sb->chunksize);
>  	sb->daemon_sleep = __le32_to_cpu(sb->daemon_sleep);
>  	sb->sync_size = __le64_to_cpu(sb->sync_size);

> +	sb->write_behind = __le32_to_cpu(sb->sync_size);

Obviously, sync_size should be write_behind in the above line.

