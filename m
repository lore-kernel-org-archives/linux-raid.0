From: Andre Tomt <andre@tomt.net>
Subject: Re: raid10 resync hangs in 4.2.6, 4.3
Date: Mon, 23 Nov 2015 10:52:10 +0100
Message-ID: <5652E1CA.3050907@tomt.net>
References: <564F6304.3040502@tomt.net> <5652DA63.9080309@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5652DA63.9080309@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid <linux-raid@vger.kernel.org>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 23. nov. 2015 10:20, Artur Paszkiewicz wrote:
> Hi Andre,
>
> I've recently sent a patch for a similar problem, I suspect the root
> cause is the same here. Please check out this patch:
>
> http://marc.info/?l=linux-raid&m=144665464232126&w=2

Indeed this is where the bisect just landed me. Going to test the fix 
out later today.

Thanks!

And also thanks to Roy Sigurd Karlsbakk for confirming I had not gone 
completely off the rails :-)

> atomt@mental:~/build/linux-upstream$ git bisect bad
> c31df25f20e35add6a453328c61eca15434fae18 is the first bad commit
> commit c31df25f20e35add6a453328c61eca15434fae18
> Author: Kent Overstreet <kent.overstreet@gmail.com>
> Date:   Wed May 6 23:34:20 2015 -0700
>
>     md/raid10: make sync_request_write() call bio_copy_data()
>
>     Refactor sync_request_write() of md/raid10 to use bio_copy_data()
>     instead of open coding bio_vec iterations.
>
>     Cc: Christoph Hellwig <hch@infradead.org>
>     Cc: Neil Brown <neilb@suse.de>
>     Cc: linux-raid@vger.kernel.org
>     Reviewed-by: Christoph Hellwig <hch@lst.de>
>     Acked-by: NeilBrown <neilb@suse.de>
>     Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
>     [dpark: add more description in commit message]
>     Signed-off-by: Dongsu Park <dpark@posteo.net>
>     Signed-off-by: Ming Lin <mlin@kernel.org>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>
> :040000 040000 de7fe22262d763cd544d0dbc53039926e5c9a6f4 8cf70fec46bcc652fd3756eb6edd1a746b41a4cd M	drivers

