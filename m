From: NeilBrown <neilb@suse.de>
Subject: Re: More ddf container woes
Date: Mon, 14 Mar 2011 19:02:52 +1100
Message-ID: <20110314190252.16d50cc2@notabene.brown>
References: <4D5FA5C4.8030803@gmail.com>
	<4D63688E.5030501@gmail.com>
	<20110223171712.09509f9e@notabene.brown>
	<4D67ECA2.2020201@gmail.com>
	<20110303093136.586df7e7@notabene.brown>
	<4D788D2D.80706@gmail.com>
	<4D7A0C78.2080402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D7A0C78.2080402@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Mar 2011 12:50:16 +0100 Albert Pauw <albert.pauw@gmail.com> wrote:

>   More experiments with the same setup
> 

Hi Albert,
 thanks again for this testing.

> To sum it up, there are two problems here:
> 
> - A failed disk in a subarray isn't automatically removed and marked 
> "Failed" in the container, although in some cases it does (see above).
> Only after a manual "mdmon --all" will this take place.

I think this is fixed in my devel-3.2 branch

   git://neil.brown.name/mdadm devel-3.2

Some aspects of it a fixed in the 'master' branch, but removing a
device properly from a container won't be fixed in 3.1.x, only 3.2.x

> 
> - When two subarrays have failed disks, are degraded, but operational 
> and I add a spare disk to the container, both will pick up the spare
> disk for replacement. They won't do this in parallel, but in sequence, 
> but nevertheless use the same disk.

I haven't fixed this yet, but can easily duplicate it.  There are a
couple of issues here that I need to think through before I get
it fixed properly.

Hopefully tomorrow.

Thanks,
NeilBrown


> 
> Albert
> 

