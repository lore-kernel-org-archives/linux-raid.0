From: Phil Turmel <philip@turmel.org>
Subject: Re:
Date: Sun, 19 Jun 2011 14:40:58 -0400
Message-ID: <4DFE42BA.1050500@turmel.org>
References: <20110618203954.129920@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110618203954.129920@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Dragon,

On 06/18/2011 04:39 PM, Dragon wrote:
> Monitor your background reshape with "cat /proc/mdstat".
> 
> When the reshape is complete, the extra disk will be marked "spare".
> 
> Then you can use "mdadm --remove".
> -->after a view days the reshape was done and i take the disk out of the raid -> many thx for that

Good to hear.

>> at this point i think i take the disk out of the raid, because i need the space of
> the disk.
> 
> Understood, but you are living on the edge.  You have no backup, and only one drive
> of redundancy.  If one of your drives does fail, the odds of losing the whole array
> while replacing it is significant.  Your Samsung drives claim a non-recoverable read
> error rate of 1 per 1x10^15 bits.  Your eleven data disks contain 1.32x10^14 bits,
> all of which must be read during rebuild.  That means a _13%_ chance of total
> failure while replacing a failed drive.
> 
> I hope your 16T of data is not terribly important to you, or is otherwise replaceable.
> --> nice calculation, where do you have the data from?
> --> most of it is important, i will look for a better solution

The error rate is from Samsung, for your HD154UI drives:
http://www.samsung.com/latin_en/consumer/monitor-peripherals-printer/hard-disk-drives/internal/HD154UI/CKW/index.idx?pagetype=prd_detail&tab=specification

error rate = 1 / 1*10^15 = 1x10^-15

The rest comes from your setup:
11 disks * (1465138496 * 1024) bytes/disk * 8 bits/bytes = 1.32026560152e+14

% odds of failure = (data quantity * error rate) * 100%

[...]

> --> and than, ext4 max size is actually 16TB, what should i do?

I've been playing with XFS.  The only significant maintenance drawback I've identified is that it cannot be shrunk.  Not even offline.  It's not really holding me back, though, as I tend to layer LVM on top of my raid arrays, then allocate to specific volumes.  I always hold back a substantial fraction of the space for future use of "lvextend".

> --> for an end-user you have many knowledge about swraid ;)

Thank you.  I was a geek before I became an engineer :) .

Phil
