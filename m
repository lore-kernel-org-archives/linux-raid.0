From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Simultaneous assembly on multiple hosts
Date: Mon, 06 May 2013 11:05:34 +0200
Message-ID: <5187725E.5050803@profitbricks.com>
References: <20130504020146.GD31411@chc-5.metaname.net> <20130506163203.7a65786b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506163203.7a65786b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Neil Matai <neil@matai.kiwi.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06.05.2013 08:32, NeilBrown wrote:
> On Sat, 4 May 2013 14:01:46 +1200 Neil Matai <neil@matai.kiwi.nz>
> wrote:
> 
>> Hi all,
>> 
>> Is it dangerous have an array assembled on two hosts at the same
>> time? Say I have servers A and B exporting devices a and b via
>> ATA over Ethernet or similar to hosts C and D.  If a and b are
>> components of an array then both C and D automatically assemble
>> the array as soon as the components a and b are exported but is
>> this safe (on the proviso that only one of C or D is ever writing
>> to the array at any time and that there is no write-behind
>> caching above the array device)?
>> 
> 
> Yes, it is dangerous. Both hosts will try to update the metadata
> and will trip over each other.

This is why we've implemented automatic super block + bitmap reload
upon first IO. Before, the MD device acts as a read-only device with
read-only super block. This is rather complex to make it safe.
This is also difficult to merge with mainline behavior.

Get yourself a kernel developer. ;-)

Cheers,
Sebastian
