From: Andries.Brouwer@cwi.nl
Subject: Re: PATCH - change to blkdev->queue calling triggers BUG in md.c
Date: Mon, 2 Sep 2002 10:53:55 +0200 (MEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <UTC200209020853.g828rtj03830.aeb@smtp.cwi.nl>
Return-path: <linux-raid-owner@vger.kernel.org>
To: neilb@cse.unsw.edu.au, torvalds@transmeta.com
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> HOWEVER, that disk change checking really should be done by
> the generic layers, and it should be done after the open() anyway
> (and not by the open)

Are you sure?
I am inclined to think that this would be an undesirable change of
open() semantics. Traditionally, and according to all standards,
open() will return ENXIO when the device does not exist.

Andries
