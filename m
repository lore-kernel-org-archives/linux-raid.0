From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:55:05 +1100
Message-ID: <20110217085505.1deec298@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5BB4EA.8030907@texsoft.it>
	<AANLkTikiP+PTJzpQomr++4d0chRww3gOq0R-J2-vaQ1-@mail.gmail.com>
	<20110216140024.GA18707@cthulhu.home.robinhill.me.uk>
	<AANLkTikeGuar5eBb7fv3+bLt=Z=bM9Zt7LfKeshxxJ9U@mail.gmail.com>
	<AANLkTi=DpeH0Ba2T_wJHuSYXzORpfW5W42SP6bUkBf-f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=DpeH0Ba2T_wJHuSYXzORpfW5W42SP6bUkBf-f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 11:21:50 -0300 Roberto Spadim <roberto@spadim.com.br>
wrote:

> since we have the option1 done, why continue with raid1 code? could we
> port write-behind to raid10 code?

No.  write-behind depends on write-mostly, and write-mostly only really makes
sense for RAID1.  I much prefer to keep these two code bases separate.

> another thing, could raid10 work without replica? like a raid0?

Why don't you try it?  Choose a layout that asks for only 1 copy of the data.
It should work.

> 
> why? just to remove many files with the same function (raid1and raid0,
> if raid10 do the same work, many some mdadm changes allow us to
> --level=1 to understand that's raid10 without stripe, --level=0 is
> raid10 without mirrors)

Again, RAID0 has some features that RAID10 doesn'tand cannot.  I suggest you
read man pages (e.g. 'man md') to find out the details.

Also the RAID0 code is much simpler and hence possibly faster.

NeilBrown

