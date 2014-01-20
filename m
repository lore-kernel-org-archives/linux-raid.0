From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: [PATCH] raid6check.c add page size check and repair
Date: Mon, 20 Jan 2014 17:11:41 +0100
Message-ID: <52DD4ABD.5060605@itwm.fraunhofer.de>
References: <20140118181823.GA15757@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140118181823.GA15757@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Piergiorgio,

I'm going to review it in more detail later on this week and I think I 
also still have an outstanding patch. But on quick glance, I think your 
patch introduces a memory leak.

 > @@ -152,13 +165,14 @@
>   	char *stripe_buf = xmalloc(raid_disks * chunk_size);
>   	char **stripes = xmalloc(raid_disks * sizeof(char*));
>   	char **blocks = xmalloc(raid_disks * sizeof(char*));
> +	char **blocks_page = xmalloc(raid_disks * sizeof(char*));
>   	int *block_index_for_slot = xmalloc(raid_disks * sizeof(int));
>   	uint8_t *p = xmalloc(chunk_size);
>   	uint8_t *q = xmalloc(chunk_size);
>   	int *results = xmalloc(chunk_size * sizeof(int));
>   	sighandler_t *sig = xmalloc(3 * sizeof(sighandler_t));

I don't see free(blocks_page).

Btw, clangs static code checker is rather good to find such issues. 
Actually, it reports several issues with mdadm, I just didn't have the 
time to look into it in more detail.

Btw2: Any chance you could at least add the '-p' argument to your diff 
command? I think if you just would use git, it would do that automatically.


Thanks,
Bernd


