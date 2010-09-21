From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Why does MD overwrite the superblock upon temporary disconnect?
Date: Tue, 21 Sep 2010 15:34:54 +1200
Message-ID: <4C9827DE.9040902@sauce.co.nz>
References: <20100921025058.79B24E3096C@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100921025058.79B24E3096C@mail.futurelabusa.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Schatzman <james.schatzman@futurelabusa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Schatzman wrote:
> I have seen quite a number of people writing about what happens to their SATA RAID5 arrays when several drives get accidentally unplugged. Especially with port multipliers and external drive boxes with eSata cables, this can happen rather easily.

In this scenario, if you are using md UUIDs in your mdadm.conf, an 
"mdadm -A --force /dev/mdX", has worked fine for me on a number of 
occasions.

Quoting the man page:

"An array which requires --force to be started may contain data 
corruption.  Use it carefully."

Therefore a fsck is a good idea afterwards.

Regards,

Richard
