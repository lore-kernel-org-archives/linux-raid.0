From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: [PATCH v3 0/2] Reorganize raid*_make_request to clean up code
Date: Mon, 5 Dec 2016 13:04:03 -0700
Message-ID: <CAANLjFpzcLc-Ju_rOWYhGF4mbh7zddAzo=JgwNWBDuWey+=tGg@mail.gmail.com>
References: <20161205200258.6653-1-robert@leblancnet.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205200258.6653-1-robert@leblancnet.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Robert LeBlanc <robert@leblancnet.us>
List-Id: linux-raid.ids

And also rebased against for-next.
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Dec 5, 2016 at 1:02 PM, Robert LeBlanc <robert@leblancnet.us> wrote:
> In response to Christoph, I've broken the read and writes into their own
> functions to make the code even cleaner. Since it is such a big change, I broke
> up the commits into this series instead of creating a v2 of the previous patch.
>
> Changes since v2:
>  Shaohua Li
>  * Make md_write_start before wait_barrier
>  * Move I/O in recovery stripe test to write path
>  * Changed to if/then instead of return in __make_request
>
> Changes since v1:
>
>  John Stoffel
>  * Changed to if/then instead of return in raid1_make_request
>
>  Neil Brown
>  * Moved wait_barrier into raid1_{read,write}_request so that it could be after
>    ->suspend_{hi,lo}. This prevents a write blocking a resync until the suspend
>    region is moved.
>
> Robert LeBlanc (2):
>   md/raid1: Refactor raid1_make_request
>   md/raid10: Refactor raid10_make_request
>
>  drivers/md/raid1.c  | 259 +++++++++++++++++++++++++++-------------------------
>  drivers/md/raid10.c | 215 ++++++++++++++++++++++---------------------
>  2 files changed, 245 insertions(+), 229 deletions(-)
>
> --
> 2.10.2
>
