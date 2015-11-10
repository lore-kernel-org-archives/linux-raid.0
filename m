From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 16:41:45 -0500
Message-ID: <56426499.8000205@turmel.org>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2015 04:33 PM, Mathias Mueller wrote:
> Hi Phil,
> 
>>> This both combinations
>>
>> Well, I gave you *four* combinations for order, and two suggestions for
>> chunk size.  Eight combinations to try.
> 
> Sorry, this two words were just the beginning of a sentence, which I
> didn't finish an forgot to remove :)
> 
> I tried 16 combinations at all (eight with --data-offset=1024 and eight
> with --data-offset=2048), the following four combinations gave the
> "/dev/md0 has unsupported feature(s)" message occurs:
> 
> --data-offset=1024 --chunk 64: sde sdd sdb sdc
> --data-offset=1024 --chunk 512: sde sdd sdb sdc
> --data-offset=1024 --chunk 64: sde sdb sdd sdc
> --data-offset=1024 --chunk 512: sde sdb sdd sdc
> 
> the other four combinations with --data-offset=1024 and all eight
> combinations with --data-offset=2048 gave
> 
> fsck.ext2: Superblock invalid, trying backup superblocks...
> fsck.ext2: Bad magic number in super-block while trying to open /dev/md0

You're not providing enough information.  Show the new vs. old
name/serial combinations, then show the --create and fsck
command/output, one by one.

For now, use data offset 2048 for all of them.

Phil
