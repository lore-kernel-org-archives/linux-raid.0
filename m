From: Neil Brown <neilb@suse.de>
Subject: Re: stopped array, but /sys/block/mdN still exists.
Date: Thu, 3 Jan 2008 15:44:17 +1100
Message-ID: <18300.26657.7543.315722@notabene.brown>
References: <cccedfc60801021315l63b2123du3b1267ebd51cc633@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Wednesday January 2
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 2, jnelson-linux-raid@jamponi.net wrote:
> This isn't a high priority issue or anything, but I'm curious:
> 
> I --stop(ped) an array but /sys/block/md2 remained largely populated.
> Is that intentional?

It is expected.
Because of the way that md devices are created (just open the
device-special file), it is very hard to make them disappear in a
race-free manner.  I tried once and failed.  It is probably getting
close to trying again, but as you say: it isn't a high priority issue.

NeilBrown
