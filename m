From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] md - 8 of 8 - Support reshaping raid1 arrays - adding
 or removing drives.
Date: Fri, 28 May 2004 00:31:16 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040528003116.6ed21a94.akpm@osdl.org>
References: <20040528163700.9426.patches@notabene>
	<E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> This requires allocating a new pool of "r1bio" structures which a different
>  number of bios, suspending IO, and swapping the new pool in place of the old.
>  (and a few other related changes).

Wanna send me the missing hunk?


drivers/md/raid1.c: In function `r1bio_pool_alloc':
drivers/md/raid1.c:49: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:53: dereferencing pointer to incomplete type
drivers/md/raid1.c:55: dereferencing pointer to incomplete type
drivers/md/raid1.c: In function `r1buf_pool_alloc':
drivers/md/raid1.c:81: dereferencing pointer to incomplete type
drivers/md/raid1.c:88: dereferencing pointer to incomplete type
drivers/md/raid1.c:115: dereferencing pointer to incomplete type
drivers/md/raid1.c:77: warning: `j' might be used uninitialized in this function
drivers/md/raid1.c: In function `r1buf_pool_free':
drivers/md/raid1.c:132: dereferencing pointer to incomplete type
drivers/md/raid1.c: In function `init_resync':
drivers/md/raid1.c:985: structure has no member named `poolinfo'
drivers/md/raid1.c: In function `run':
drivers/md/raid1.c:1179: structure has no member named `poolinfo'
drivers/md/raid1.c:1179: structure has no member named `poolinfo'
drivers/md/raid1.c:1180: structure has no member named `poolinfo'
drivers/md/raid1.c:1182: structure has no member named `poolinfo'
drivers/md/raid1.c:1183: structure has no member named `poolinfo'
drivers/md/raid1.c:1186: structure has no member named `poolinfo'
drivers/md/raid1.c:1286: structure has no member named `poolinfo'
drivers/md/raid1.c:1287: structure has no member named `poolinfo'
drivers/md/raid1.c: In function `stop':
drivers/md/raid1.c:1305: structure has no member named `poolinfo'
drivers/md/raid1.c:1306: structure has no member named `poolinfo'
drivers/md/raid1.c: In function `raid1_reshape':
drivers/md/raid1.c:1356: dereferencing pointer to incomplete type
drivers/md/raid1.c:1357: dereferencing pointer to incomplete type
drivers/md/raid1.c:1386: structure has no member named `poolinfo'
drivers/md/raid1.c:1387: structure has no member named `poolinfo'
