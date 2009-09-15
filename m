From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 07:23:08 +0000 (UTC)
Message-ID: <h8nfcs$n8p$2@ger.gmane.org>
References: <h8nbt5$n8p$1@ger.gmane.org> <4AAF3809.7080802@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009 02:45:29 -0400, berk walker wrote:

> I can not believe the question.  What file system might this be?

Umm, what's your problem with my question?

And why would it matter which file system I'm using?


_My_ problem is that I have a bunch of disks which are not as reliable as 
I'd like. Yes I could go and buy a new heap of 1TB disks, but frankly I'd 
like to avoid that. These disks are "good enough" for the data that's on 
them. I'll replace one if it fails entirely -- assuming that I can 
rebuild the RAID6 array when I do that. However, since the rewrite-after-
read code has caused bad sectors to accumulate on all of these disks, I 
can't even do that at the moment.

(And, since there's no command which knows how to recover bad spots from 
the other RAID disks yet (I hope to be able to work on _that_ problem 
next week), I can't even use ddrescue to copy one almost-good disk to a 
new one.)

-- 
Matthias Urlichs

