From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 13:13:28 +0200
Message-ID: <516E83D8.2070908@bucksch.org>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org> <516DFC4F.5000908@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DFC4F.5000908@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Robert L Mathews <lists@tigertech.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Adam Goryachev wrote, On 17.04.2013 03:35:
> Obviously, if they suffered a two disk failure then they won't be here
> asking for help will they:)

Wrong, sadly. I suffered a 1 disk failure, and I am here asking for 
help. And nobody can give it.

Again: I have a RAID5, and 1 (one) disk failed, so I should be fine, but 
I cannot read the data anymore, no way to get at it. That's because md 
ejected a good (!) drive to start with, and refuses to take it back (!). 
(And then another drive failed during resync.) If you have a way, please 
do show me, see thread 'Disk wrongly marked "spare", need to force 
re-add it'

The problem isn't double disk failure. The problem is bugs in md 
implementation.

> The Linux kernel advises Linux md that the block
> device is gone, so Linux md discards the block device and stops trying
> to use it. Personally, I don't see that Linux md has a lot of choice in
> the matter

True. But often, such errors are temporary. For example, a loose cable. 
I must be able to re-add the device as a good device with data. But I 
can't, md doesn't let me.

My case was even more unbelievable: md ejected perfectly good drives 
simply because I upgraded the OS. (This happened with 2 independent 
arrays, so not coincidence.)

Also, a single sector being unreadable/unwritable doesn't count as "disk 
failure" in my book, and shouldn't eject the whole disk. If I have 2 
sectors on 2 different disks that are unreadable, md currently trashes 
the whole array and doesn't let me read anything at all anymore. That's 
obviously broken, but unfortunately the sad reality.

See http://neil.brown.name/blog/20110216044002#1


(And, BTW, RAID6 doesn't really help with this problem, because it's 
quite possible that 3 disks have sectors unreadable/unwritable.)
