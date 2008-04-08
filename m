From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Re-assembling a software RAID in which device names have changed.
Date: Tue, 08 Apr 2008 22:37:34 +0400
Message-ID: <47FBBB6E.8040307@msgid.tls.msk.ru>
References: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>	 <47FBAA76.20008@msgid.tls.msk.ru> <fa037c550804081055p2d2550ccs8dfab22d2edb6920@mail.gmail.com>
Reply-To: mjt@tls.msk.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550804081055p2d2550ccs8dfab22d2edb6920@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sean H." <silverwraithii@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[Please respect the Reply-To header]

Sean H. wrote:
[]
> My mdadm.conf is configured with UUIDs:

Ok.

> DEVICE partitions

Ok.
> ARRAY /dev/md0 level=raid5 num-devices=5
> uuid=58dcdaf3:bdf3f176:f2dd1b6b:f095c127


> Tried the following: 'mdadm --assemble /dev/md0 --uuid
> 58dcdaf3:bdf3f176:f2dd1b6b:f095c127'
> ... and got this: mdadm: /dev/md0 assembled from 2 drives - not enough
> to start the array.
> (Which is what I've been getting for a while, now.)

Ok.  So it's a different problem you have.  What's the
reason you think it's due to re-numbering/naming of the
disks?

When you unplugged 3 your disks, I suspect linux noticed
that fact and md layer marked them as "failed" in the
array, with the 2 still here.  Now, when you have all 5
of them again, 2 of them (the ones which were left in
the system) are "fresh", and 3 (the ones which were
removed) are "old".  So you really don't have enough
fresh drives to start the array.

Now take a look at verbose output of mdadm (see -v option).
If my guess is right, use --force option.  And take a look
at the Fine Manual, after all -- at the section describing
assemble mode.

> It's possible to correct this issue by unplugging the three drives and
> plugging them back in and rebooting, so the drives get their original
> /dev/sd* locations, is it not? (Even if it it possible, I'd like to
> learn how to fix problems like this at the software level over the
> hardware level.)

Please answer this question.  Why do you think that the array
does not start because of disk renumbering?

/mjt

