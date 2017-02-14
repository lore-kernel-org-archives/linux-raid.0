From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH v2 0/5] md: use bio_clone_fast()
Date: Tue, 14 Feb 2017 08:31:28 -0700
Message-ID: <c4560059-002a-0aa7-0d42-8e293b43033d@fb.com>
References: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487086143-10255-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 02/14/2017 08:28 AM, Ming Lei wrote:
> Hi,
> 
> This patches replaces bio_clone() with bio_fast_clone() in
> bio_clone_mddev() because:
> 
> 1) bio_clone_mddev() is used in raid normal I/O and isn't in
> resync I/O path, and all the direct access to bvec table in
> raid happens on resync I/O only except for write behind of raid1.
> Write behind is treated specially, so the replacement is safe.
> 
> 2) for write behind, bio_clone() is kept, but this patchset
> introduces bio_clone_bioset_partial() to just clone one specific 
> bvecs range instead of whole table. Then write behind is improved
> too.

You can add my reviewed-by to the first patch. Shaohua, I'm fine
with you carrying this in the md tree, that would be the easiest
way forward.

-- 
Jens Axboe
