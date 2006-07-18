From: Neil Brown <neilb@suse.de>
Subject: Re: which disk the the one that data is on?
Date: Tue, 18 Jul 2006 19:51:59 +1000
Message-ID: <17596.44863.331069.588455@cse.unsw.edu.au>
References: <e3edb0fa0607180053x7a29bf71se8d30c591e7d10d5@mail.gmail.com>
	<17596.41907.608404.634683@cse.unsw.edu.au>
	<e3edb0fa0607180223q11193d9ey6a6569bded1feb4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Shai on Tuesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 18, shaibn@gmail.com wrote:
> Hi,
> 
> So if I were to want to stop the resync process on a very large array
> (1.4T), since it is in the middle of the day and makes work slower...
> How can I tell which drive is the one that is being used to check all
> the rest of the data? Or in other words, how can I stop the resync
> process and let it cont. later?

There is no "one that is being used to check all the rest".  They are
all in this together.

But if you want to stop the resync because it is slowing things down
then write a small number to /proc/sys/dev/raid/speed_limit_min
e.g.

  echo 10 > /proc/sys/dev/raid/speed_limit_min

This won't actually stop it, but it will make it go very slowly so as
not to interfere with anything else.

NeilBrown
