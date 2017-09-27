From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Wed, 27 Sep 2017 17:30:46 -0400
Message-ID: <378e1fe4-6844-b6f4-3242-33657a0b0219@gmail.com>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y3p372b0.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/25/2017 01:52 AM, NeilBrown wrote:
> 
> Creating an array by opening a block-device with major number of 9
> will transparently load the md module if needed.
> Creating an array by opening
>     /sys/module/md_mod/parameters/new_array
> and writing to it won't, it will just fail if md_mod isn't loaded.
> 
> So when opening that file fails with ENOENT, run "modprobe md_mod" and
> try again.
> 
> This fixes a bug whereby if you have "CREATE names=yes" in mdadm.conf,
> and the md modules isn't loaded, then creating or assembling an
> array will not honor the "names=yes" configuration.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>   mdopen.c | 4 ++++
>   1 file changed, 4 insertions(+)

Applied!

Thanks,
Jes

