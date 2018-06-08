From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] md: Unify mddev destruction paths
Date: Thu, 7 Jun 2018 19:36:27 -0600
Message-ID: <82fb97f6-b41b-37cf-b4fd-51e20dc4b4d3@kernel.dk>
References: <20180608005254.6692-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608005254.6692-1-kent.overstreet@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>, shli@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/7/18 6:52 PM, Kent Overstreet wrote:
> Previously, mddev_put() had a couple different paths for freeing a
> mddev, due to the fact that the kobject wasn't initialized when the
> mddev was first allocated. If we move the kobject_init() to when it's
> first allocated and just use kobject_add() later, we can clean all this
> up.
> 
> This also removes a hack in mddev_put() to avoid freeing biosets under a
> spinlock, which involved copying biosets on the stack after the reset
> bioset_init() changes.

Looks good to me, much nicer than the previous hack.

-- 
Jens Axboe
