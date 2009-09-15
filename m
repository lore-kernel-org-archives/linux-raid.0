From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 10:52:07 +0000 (UTC)
Message-ID: <h8nrkn$n8p$5@ger.gmane.org>
References: <h8nbt5$n8p$1@ger.gmane.org>
	<70ed7c3e0909150340q4ae91cb1j7eaae473c6d94c9a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009 13:40:44 +0300, Majed B. wrote:

> Would anyone suggest a better solution?

You should tell ddrescue to log which sectors it failed to copy. You can 
then recover the missing data by reading the stuff at that offset from 
the other disks, and XORing the bytes.

I plan to write a program which does that (and which also understands 
RAID1 and RAID6). How long can you survive without your data?

-- 
Matthias Urlichs

