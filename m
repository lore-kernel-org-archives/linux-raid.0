From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 3-disk RAID5 won't assemble
Date: Fri, 20 Oct 2017 21:34:35 +0100
Message-ID: <59EA5DDB.2020400@youngman.org.uk>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Elder <elder@ieee.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/10/17 20:51, Alex Elder wrote:
> I have a 3-disk RAID5 with identical drives that won't assemble.
> 
> The event counts on two of them are the same (20592) and one is
> quite a bit less (20466).  I do not expect failing hardware.

First things first. Have you looked at the raid wiki?
https://raid.wiki.kernel.org/index.php/Linux_Raid

In particular, take a read of the "When things go wrogn" section. And
especially, do a "smartctl -x" - are your drives desktop drives?
> 
> The problem occurred while I was copying some large files to
> the XFS volume on the device, while doing something else that
> ate up all my memory.  (It was a long time ago so I that's
> about as much detail as I can provide--I assumed the OOM killer
> ultimately was to blame, somehow.)

Have you rebooted since then? If that really was the problem, the array
should have failed the first time you rebooted.
> 
> It *sounds* like the two drives with the same event count should
> be enough to recover my volume.  But forcibly doing that is scary
> so I'm writing here for encouragement and guidance.
> 
>   {1156} root@meat-> mdadm --stop /dev/md0
>   mdadm: stopped /dev/md0
>   {1157} root@meat-> mdadm --assemble /dev/md0 /dev/sd[bcd]1
>   mdadm: /dev/md0 assembled from 2 drives - not enough to start the
> array  while not clean - consider --force.
>   {1158} root@meat->

Okay. Do NOT force all three drives. Forcing the two with the same event
count is safe - you have no redundancy so it's not going to start
mucking about with the drives. But first you need to be certain it's not
desktop drives and a timeout problem.
> 
> I can provide plenty more information, but thought I'd start by
> introducing the problem.
> 
> How should I proceed?  Thanks.
> 
Read the wiki?

Make sure it's not the timeout problem !!!

Does your array have bitmap enabled?

Once we're happy that your drives are fine, you can force the two good
drives, and then re-add the third. If you have bitmaps enabled, this
will bring it quickly up to scratch without needing a full resync.

And once the third is re-added, you need to do a scrub.

But it looks like everything is pretty much fine. Recovery *should* be
easy (famous last words ...)

If you're not sure you're happy, post all the requested diagnostics to
the list - preferably inline in your emails - and let an expert take a look.

Cheers,
Wol
