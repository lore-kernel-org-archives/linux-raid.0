From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Mon, 2 Aug 2004 00:10:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408020010.07572.maarten@ultratux.net>
References: <cds76e$ee7$1@terminus.zytor.com> <200408011503.20452.maarten@ultratux.net> <20040801180536.GA3897@jim.sh>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040801180536.GA3897@jim.sh>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 01 August 2004 20:05, you wrote:
> > I eventually got a kernel panic when copying large amounts of data to a
> > [degraded] raid6 array, which this time was the full 600 GB size.
> > Don't know if it is helpful to anyone but info below:
>
> The panic is from reiserfs, and it's occuring because the FS is
> getting corrupted due to the raid6 problems.

Ok.  Thanks.  I expected as much.  I will now try to make a raid 5 array 
instead, and make double sure I do not suffer the same fate.
I am cautious because I do not want to be bitten by a bug in this SuSE kernel 
or a bug in one of the SATA drivers. 

Pity though, that this was not discovered when testing with the smallish 
arrays I ran yesterday.  Seems like it takes a lot of beating to reproduce.

Maarten

> -jim

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

