From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] badblocks: badblocks_set/clear update unacked_exist
Date: Fri, 21 Oct 2016 10:15:28 -0600
Message-ID: <ef73bc09-433d-8c3b-d70f-3400d4624ed5@kernel.dk>
References: <39f303dcb7bdf2958b6f82a0646467dfbc8d1abd.1476999400.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <39f303dcb7bdf2958b6f82a0646467dfbc8d1abd.1476999400.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Cc: tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

On 10/20/2016 03:40 PM, Shaohua Li wrote:
> When bandblocks_set acknowledges a range or badblocks_clear a range,
> it's possible all badblocks are acknowledged. We should update
> unacked_exist if this occurs.

Applied, thanks.

-- 
Jens Axboe

