From: Jim Paris <jim@jtan.com>
Subject: Re: mdadm output format
Date: Thu, 2 Sep 2004 15:23:06 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040902192306.GA5095@jim.sh>
References: <1094149263.8447.42.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1094149263.8447.42.camel@rich>
To: rich turner <rich@storix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> also, is there any way with mdadm to create a raid device that does not
> have persistent superblock? with raidtools there is a flag to indicate
> whether you want a persistent superblock.

man mdadm

       -B, --build
              Build a legacy array without superblocks.

-jim

