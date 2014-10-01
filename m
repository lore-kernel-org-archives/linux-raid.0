From: David Brown <david.brown@hesbynett.no>
Subject: Re: raid1 - ssd, doubts
Date: Wed, 01 Oct 2014 09:33:49 +0200
Message-ID: <542BAE5D.5040108@hesbynett.no>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/09/14 16:50, Roberto Spadim wrote:
> hi guys!
> i will use a ssd raid1, i want know if raid1 trim is supported at mdadm
> i will use a 840 evo (or evo pro not selected the right one yet) 500gb
> each, raid1, today database size is 100gb, i think it will grow
> 10gb/year, i had many space...
> 
> the point are: madm raid1 trim is supported? or should i use lvm?
> should i partition it with 400gb and leave 100gb untouched? or should
> i use a hdd+ssd and dmcache?
> 
> 
> :) thanks guys, that's a small enterprise solution, they can't buy
> raid cards and sas harddisk are same price of ssd :)
> 
> any idea/experience and information is wellcome
> 

With reasonably modern SSD's, don't worry about trim.  Make sure you've
got enough over-provisioning (look at the specs for the SSD - and if
necessary, leave a 5-10% of the space on the disk as unpartitioned free
space).

The main point of trim is to return blocks to the list of blocks
available for recycling - if you have plenty of overprovisioning, this
list (along with the list of blocks already erased) is always going to
have plenty in it.  Thus trim doesn't add anything useful here.

The second effect of trim is to reduce the number of blocks copied
during garbage collection.  As it is unlikely that many extra blocks are
copied, and it is done at off-peak times by the SSD, this makes very
little difference - certainly nothing you would notice in most use-cases.

In other words, you should not notice whether trim is used or not.

Having said that, I believe trim works on raid1 with current kernels.
But make sure you only do off-line trim (fstrim), not the "discard"
mount option in ext4 (or equivalent on other filesystems), as discard
mount will give you noticeably slower performance on many operations.


