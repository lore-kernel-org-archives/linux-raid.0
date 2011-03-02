From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ddf questions
Date: Thu, 3 Mar 2011 09:31:36 +1100
Message-ID: <20110303093136.586df7e7@notabene.brown>
References: <4D5FA5C4.8030803@gmail.com>
	<4D63688E.5030501@gmail.com>
	<20110223171712.09509f9e@notabene.brown>
	<4D67ECA2.2020201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D67ECA2.2020201@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 25 Feb 2011 18:53:38 +0100 Albert Pauw <albert.pauw@gmail.com> wrote:

>   Hi Neil,
> 
> I investigated a bit further, and here are my findings:
> 
> Looking at /proc/mdstat I see the following:
> 
> - When I create a ddf containter with a name (say /dev/md0), I stop it 
> and start it again, the name has always changed to /dev/md127,
> don't know if this is intentional.

It is intentional.  Numbers aren't really meaningful for ddf containers.
mdadm should also create /dev/md/ddf0 as well which points to md127 and I
consider 'ddf0' to be the 'official' name.  I hope to make the 'md127'
disappear eventually.


> - After creating the containter, all disks are marked as spare, 
> designated with the (S) ending. However, when I put a disk in an array, it
> still stays marked as (S) in the containter entry in /proc/mdstat. I 
> think those disks should be branded (S) anymore.

Yes, the (S) in the container is a bit misleading.  It simply means that the
device isn't active in 'this' array - which is true because the container
isn't really an active array.
I've made a note to tidy this up at some stage.


> I also noticed that a RAID5 array created in a containter cannot be 
> expanded with another disk (option -G) as it can in normal setup (i.e. 
> without using the container).
> The same hold for a RAID1 where you cannot add a third disk.

Yes.. ddf support is really still quite preliminary.  While reshaping arrays
should be possible it requires quite a bit of coding in mdadm which it is
hard to get motivated about .....

> 
> I hope this gives you more clues about a possible fix?

Yes, very helpful.
I hope to fix the bugs in a week or so.  The missing features will take
longer.

Thanks,
NeilBrown

