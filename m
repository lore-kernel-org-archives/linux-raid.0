From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: Stripe Block Size.
Date: Mon, 05 Apr 2004 11:03:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1081180986.4745.4.camel@localhost.localdomain>
References: <40718078.7010303@ocis.net>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <40718078.7010303@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2004-04-05 at 10:51, Jason C. Leach wrote:
> hi,
> 
> I have a Promise SX6000 in a RAID5 using Linux Debian on an AMD 
> AthelonXP 2500+.  This array will store mostly GIS data. So about 30% 
> large files (a few hundred megs) and 70% small files (several megs).  I 
> am curious what stripe block size to use 4-64k (the fs is reiserfs).  I 
> was thinking 32k for the stripe block size.
> 
> Thanks,
> J.

J,

If the large files are Audio/Video for streaming, then you will want a
larger stripe size.  If not, go with the smallest that you can (a small
~.h or text file will take the same amount of space as your stripe
size).

The best way to set this is to consider the total volume size.  What
will be the allocation block size be for that size of volume if it were
on a single disk for that OS?.  Set you allocation size to be the same
or some multiple of that value.

Good luck.

Matt

----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


