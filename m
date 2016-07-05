From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH v3 1/3] bcache: Remove redundant parameter for
 cache_alloc()
Date: Tue, 5 Jul 2016 11:35:19 -0600
Message-ID: <577BEFD7.9050708@fb.com>
References: <1467595405-20805-1-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467595405-20805-1-git-send-email-wangyijing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, Kent Overstreet <kent.overstreet@gmail.com>
Cc: Eric Wheeler <git@linux.ewheeler.net>, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 07/03/2016 07:23 PM, Yijing Wang wrote:
> Cache_sb is not used in cache_alloc, and we have copied
> sb info to cache->sb already, remove it.

Added this, and 2-3/3 for 4.8, thanks.

-- 
Jens Axboe
