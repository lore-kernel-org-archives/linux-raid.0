From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Incremental: Use ->validate_geometry instead of
 ->avail_size
Date: Wed, 1 Nov 2017 17:27:06 -0400
Message-ID: <7e500a7f-093d-b7d7-f02a-1e120e7bac89@gmail.com>
References: <87k1zdb5z6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k1zdb5z6.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, =?UTF-8?Q?Bj=c3=b8rnar_Ness?= <bjornar.ness@gmail.com>
List-Id: linux-raid.ids

On 10/30/2017 12:43 AM, NeilBrown wrote:
> 
> Since mdadm 3.3 is has not been correct to call ->avail_size if
> metadata hasn't been read from the device.  ->validate_geometry
> should be used instead.
> 
> Unfortunately array_try_spare() didn't get the memo, and it can crash
> when adding a spare with no metdata.
> 
> So change it to use ->validate_geometry().
> 
> Only one place remains that uses ->avail_size(), and that is safe.
> 
> Also fix a comment with a typo.
> 
> Reported-and-tested-by: Bjørnar Ness <bjornar.ness@gmail.com>
> Fixes: 641da7459192 ("super1: separate to version of _avail_space1().")
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  Incremental.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)

Memo sent to array_try_spare()!

Thanks,
Jes


