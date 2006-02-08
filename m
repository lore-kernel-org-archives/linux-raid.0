From: Chris Osicki <Krzysztof.Osicki@swisscom.com>
Subject: Re: Question: array locking, possible?
Date: Wed, 8 Feb 2006 11:49:57 +0100
Message-ID: <20060208114957.7ca58487@mwdsp001.swissptt.ch>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
	<43E8E3F4.1050409@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E8E3F4.1050409@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 07 Feb 2006 10:16:20 -0800
Mike Hardy <mhardy@h3c.com> wrote:

> 
> 
> Chris Osicki wrote:
> 
> > 
> > To rephrase my question, is there any way to make it visible to the
> > other host that the array is up an running on the this host?
> > 
> > Any comments, ideas?
> 
> Would that not imply an "unlock" command before you could run the array
> on the other host?

Yes, it would. I was thinking about an "advisory" lock, and a well
known -f option for those who know what they are doing ;-)

> 
> Would that not then break the automatic fail-over you want, as no
> machine that died or hung would issue the unlock command, meaning that
> the fail-over node could not then use the disks

If I trust my cluster software it's not a problem, I use the -f.
My concern is as I said accidentally array activation on the other node.

> 
> It's an interesting idea, I just can't think of a way to make it work
> unattended

> 
> It might be possible wrap the 'mdadm' binary with a script that "checks"
> (maybe via some deep check using ssh to execute remote commands, or just
> a ping) the hosts status and just prints a little table of host status
> that can only be avoided by passing a special --yes-i-know flag to the
> wrapper

It has been done, more or less what you are thinking about. The
cluster I'm currently working on is Service Guard on Linux. The 
original platform is HP-UX. They use LVM for mirroring and device
locking is on LVM level.  The active cluster node activates a volume
group in exclusive mode. This writes a kind of flag onto the
disk. Should the node die without a chance to clear the flag, the node
taking over the service knows what happened and forces the take-over
of the volume group.  This feature is missing on Linux.

I already have a Linux cluster which has been running for over one
year w/o problems.  I've just setup three more and to sleep better I'm
looking for a way to diminish chances of a disaster due to a operation
fault. 

Regards,
Chris

> 
> 
> -Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
