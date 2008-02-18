From: Neil Brown <neilb@suse.de>
Subject: Re: Create Raid6 with 1 missing member fails
Date: Mon, 18 Feb 2008 15:29:53 +1100
Message-ID: <18361.2497.115320.689843@notabene.brown>
References: <47B82AA4.10402@start.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sevrin Robstad on Sunday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Sevrin Robstad <quackyo@start.no>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday February 17, quackyo@start.no wrote:
> I tried to create a raid6 with one missing member, but it fails.
> It works fine to create a raid6 with two missing members. Is it supposed 
> to be like that ?

No, it isn't supposed to be like that, but currently it is.

The easiest approach if to create it with 2 drives missing, and the
extra drive immediately.
This is essentially what mdadm will do when I fix it.

Alternately you can use --assume-clean to tell it that the array is
clean.  It is actually a lie, but it is a harmless lie. Whenever any
data is written to the array, that little part of the array will get
"cleaned". (Note that this isn't true of raid5, only of raid6).

NeilBrown
