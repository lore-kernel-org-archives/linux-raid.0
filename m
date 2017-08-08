From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] block: a virtual block device driver for testing
Date: Tue, 8 Aug 2017 16:07:35 -0600
Message-ID: <a856b7a7-53ba-3e4f-4f98-d08912ad2ca3@kernel.dk>
References: <cover.1501945859.git.shli@fb.com>
 <42bfcce1-8329-c0df-7457-107b388491ff@suse.de>
 <20170807163607.msflun2r4q5tlpsk@kernel.org>
 <f6896ce5-1752-feba-fadb-dbc89dbf4e20@kernel.dk>
 <20170808210507.setdwunzrad4t7xp@kernel.org>
 <73342715-25af-da8e-ae7e-f24015432055@kernel.dk>
 <1502229619.2686.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1502229619.2686.1.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "kernel-team@fb.com" <kernel-team@fb.com>, "hare@suse.de" <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "kyungchan.koh@gmail.com" <kyungchan.koh@gmail.com>, "shli@fb.com" <shli@fb.com>
List-Id: linux-raid.ids

On 08/08/2017 04:00 PM, Bart Van Assche wrote:
> On Tue, 2017-08-08 at 15:13 -0600, Jens Axboe wrote:
>> On 08/08/2017 03:05 PM, Shaohua Li wrote:
>>>> I'm curious why null_blk isn't a good fit? You'd just need to add RAM
>>>> storage to it. That would just be a separate option that should be
>>>> set,
>>>> ram_backing=1 or something like that. That would make it less critical
>>>> than using the RAM disk driver as well, since only people that want a
>>>> "real"
>>>> data backing would enable it.
>>>>
>>>> It's not that I'm extremely opposed to adding a(nother) test block
>>>> driver,
>>>> but we at least need some sort of reasoning behind why, which isn't
>>>> just
>>>> "not a good fit".
>>>
>>> Ah, I thought the 'null' of null_blk means we do nothing for the
>>> disks. Of course we can rename it, which means this point less
>>> meaningful. I think the main reason is the interface. We will
>>> configure the disks with different parameters and do power on/off for
>>> each disks (which is the key we can emulate disk cache and power
>>> loss). The module paramter interface of null_blk doesn't work for the
>>> usage. Of course, these issues can be fixed, for example, we can make
>>> null_blk use the configfs interface. If you really prefer a single
>>> driver for all test purpose, I can move the test_blk functionalities
>>> to null_blk.
>>
>> The idea with null_blk is just that it's a test vehicle. As such, it
>> would actually be useful to have a mode where it does store the data in
>> RAM, since that enables you to do other kinds of testing as well. I'd be
>> fine with augmenting it with configfs for certain things.
> 
> Hello Jens,
> 
> Would you consider it acceptable to make the mode in which null_blk stores
> data the default? I know several people who got confused by null_blk by
> default not retaining data ...

I don't think we should change the default, since that'll then upset
people that currently use it and all of a sudden see a different
performance profile. It's called null_blk, and the device node is
/dev/nullb0. I think either one of those should reasonably set
expectations for the user that it doesn't really store your data at all.

We could add a module info blurb on it not storing data, I see we don't
have that. The initial commit said:

commit f2298c0403b0dfcaef637eba0c02c4a06d7a25ab
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Oct 25 11:52:25 2013 +0100

    null_blk: multi queue aware block test driver
    
    A driver that simply completes IO it receives, it does no
    transfers. Written to fascilitate testing of the blk-mq code.
    It supports various module options to use either bio queueing,
    rq queueing, or mq mode.

We should just add a MODULE_INFO with a short, similarly worded text.

-- 
Jens Axboe
