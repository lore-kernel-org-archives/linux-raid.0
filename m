From: Jim Paris <jim@jtan.com>
Subject: Re: RAID 5 questions
Date: Sat, 31 Jul 2004 23:31:09 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040801033109.GA23032@jim.sh>
References: <1091325475.2374.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1091325475.2374.11.camel@localhost>
To: Ninti Systems <office@ninti.com.au>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Q1: Is it true that Linux can't/shouldn't boot off a RAID 5 array?

LILO does not support booting off of RAID 5, and I don't think GRUB
does either.  I usually make a small RAID-1 partition to boot from
(mirrored across all four drives), since LILO does handle that just
fine.

> geometry = 2498/255/63, sectors = 40132503, start = 0
..
> geometry = 39813/16/63, sectors = 40132503, start = 0
> Is this an issue with software RAID? 

No.

-jim
