From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2 2/2] mdadm/util: unify stat checking blkdev into
 function
Date: Fri, 5 May 2017 11:06:47 -0400
Message-ID: <e62d1997-656e-9383-8c62-13cf4b0d422c@gmail.com>
References: <2234ff90-2ed8-217f-bdcd-ef08008f9d2c@gmail.com>
 <20170505030941.14911-1-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170505030941.14911-1-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/2017 11:09 PM, Zhilong Liu wrote:
> declare function stat_is_blkdev() to integrate repeated stat
> checking blkdev operations, it returns 'true/1' when it is a
> block device, and returns 'false/0' when it isn't.
> The devname is necessary parameter, *rdev is optional, parse
> the pointer of dev_t *rdev, if valid, assigned device number
> to dev_t *rdev, if NULL, ignores.

Both applied!

Jes


