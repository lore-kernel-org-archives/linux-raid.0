From: Neil Brown <neilb@suse.de>
Subject: Re: force mdadm
Date: Mon, 23 Jan 2006 10:06:01 +1100
Message-ID: <17364.4057.597729.853778@cse.unsw.edu.au>
References: <43D36563.4010605@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Sunday January 22
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 22, lfarkas@bppiac.hu wrote:
> hi,
> is there any way to force to put together a raid5 array? we've to a 7+1
> disks raid5 array (with 7 disks and 1 spare), but it's faild (probably
> because of heat). so currently it's 4+3:-( is there any way to force
> mdadm to put together the array and hope that we can save at least part
> of it's data?
> thank you for your help in advance.
> yours.

You could try the "--force" option...

 mdadm --assemble /dev/mdX --force /dev/sd[a-h]1

or whatever the device names are.

If that doesn't work, you will need to try to recreate the array.
Create it degraded (one missing device) using the 6 devices (in their
correct positions) that you think are most likely to have good data.

NeilBrown
