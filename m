From: Jim Paris <jim@jtan.com>
Subject: Re: Kernel panic, FS corruption  Was: Re: Call for RAID-6 users
Date: Sun, 1 Aug 2004 14:05:36 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040801180536.GA3897@jim.sh>
References: <cds76e$ee7$1@terminus.zytor.com> <200407302338.33823.maarten@ultratux.net> <200407310228.27969.maarten@ultratux.net> <200408011503.20452.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200408011503.20452.maarten@ultratux.net>
To: maarten van den Berg <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I eventually got a kernel panic when copying large amounts of data to a 
> [degraded] raid6 array, which this time was the full 600 GB size.
> Don't know if it is helpful to anyone but info below:

The panic is from reiserfs, and it's occuring because the FS is
getting corrupted due to the raid6 problems.

-jim
