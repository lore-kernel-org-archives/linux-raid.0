From: Roe Peterson <roe@liveglobalbid.com>
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Tue, 03 Sep 2002 09:27:41 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D74D4ED.FFA5539F@liveglobalbid.com>
References: <UTC200209030053.g830r9b16219.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I'm a newbie to the list (not unix, though :-), but anyhow...

Andries.Brouwer@cwi.nl wrote:

>     >  Another argument is that nobody knows whether there is
>     >  a partition table. (ZIP: "large floppy" vs "removable disk")
>     >  Another argument is that tricky things happen with disk managers.
>
>     And none of these work any better in user space.
>
> Well, in fact they do.
>
> The user knows whether she treats her ZIP like a removable disk
> or like a big floppy, that is, whether she should ask or refrain
> from asking to read the pt.

"The User Knows"?  My experience with the vast bulk of users is that
the only thing you can count on is that they _don't_ know.  Much of
anything at all, in fact.  Depending on an luser to know how her zip disk
is configured is _much_ less reliable than some minor kernel
heuristic (translate: guesswork).


