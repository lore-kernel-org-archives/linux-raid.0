From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Question: array locking, possible?
Date: Tue, 07 Feb 2006 10:16:20 -0800
Message-ID: <43E8E3F4.1050409@h3c.com>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060207185517.7bc96486@mwdsp001.swissptt.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Chris Osicki wrote:

> 
> To rephrase my question, is there any way to make it visible to the
> other host that the array is up an running on the this host?
> 
> Any comments, ideas?

Would that not imply an "unlock" command before you could run the array
on the other host?

Would that not then break the automatic fail-over you want, as no
machine that died or hung would issue the unlock command, meaning that
the fail-over node could not then use the disks

It's an interesting idea, I just can't think of a way to make it work
unattended

It might be possible wrap the 'mdadm' binary with a script that "checks"
(maybe via some deep check using ssh to execute remote commands, or just
a ping) the hosts status and just prints a little table of host status
that can only be avoided by passing a special --yes-i-know flag to the
wrapper


-Mike
