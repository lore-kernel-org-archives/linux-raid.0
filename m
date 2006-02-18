From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Raid on USB2 ?
Date: Sat, 18 Feb 2006 12:11:28 +1100
Message-ID: <87oe154gjj.fsf@rimspace.net>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A6A25B@TEXTILES.BSC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ken Walker <ken.walker@manchester.ac.uk> writes:

> Anybody tried a Raid1 or Raid5 on USB2.
>
> If so did it crawl or was it usable ?

Yes, I used this for two by two drive RAID-1 arrays.

It was usable, but not pleasantly.  The machine became very I/O bound,
with human scale delays introduced into previously "instant" processes
such as opening an IMAP mailbox, scanning a directory listing, etc.

I wouldn't advise more than two or three drives per USB controller, and
would expect poor performance even then.

    Daniel

