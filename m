From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] block: a virtual block device driver for testing
Date: Tue, 8 Aug 2017 15:13:06 -0600
Message-ID: <73342715-25af-da8e-ae7e-f24015432055@kernel.dk>
References: <cover.1501945859.git.shli@fb.com>
 <42bfcce1-8329-c0df-7457-107b388491ff@suse.de>
 <20170807163607.msflun2r4q5tlpsk@kernel.org>
 <f6896ce5-1752-feba-fadb-dbc89dbf4e20@kernel.dk>
 <20170808210507.setdwunzrad4t7xp@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170808210507.setdwunzrad4t7xp@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, kernel-team@fb.com, Kyungchan Koh <kyungchan.koh@gmail.com>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On 08/08/2017 03:05 PM, Shaohua Li wrote:
>> I'm curious why null_blk isn't a good fit? You'd just need to add RAM
>> storage to it. That would just be a separate option that should be set,
>> ram_backing=1 or something like that. That would make it less critical
>> than using the RAM disk driver as well, since only people that want a "real"
>> data backing would enable it.
>>
>> It's not that I'm extremely opposed to adding a(nother) test block driver,
>> but we at least need some sort of reasoning behind why, which isn't just
>> "not a good fit".
> 
> Ah, I thought the 'null' of null_blk means we do nothing for the
> disks. Of course we can rename it, which means this point less
> meaningful. I think the main reason is the interface. We will
> configure the disks with different parameters and do power on/off for
> each disks (which is the key we can emulate disk cache and power
> loss). The module paramter interface of null_blk doesn't work for the
> usage. Of course, these issues can be fixed, for example, we can make
> null_blk use the configfs interface. If you really prefer a single
> driver for all test purpose, I can move the test_blk functionalities
> to null_blk.

The idea with null_blk is just that it's a test vehicle. As such, it
would actually be useful to have a mode where it does store the data in
RAM, since that enables you to do other kinds of testing as well. I'd be
fine with augmenting it with configfs for certain things.

-- 
Jens Axboe

