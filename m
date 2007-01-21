From: Nix <nix@esperi.org.uk>
Subject: Re: bad performance on RAID 5
Date: Sun, 21 Jan 2007 17:08:22 +0000
Message-ID: <87wt3gtiih.fsf@hades.wkstn.nix>
References: <45AE9640.1040500@start.no> <45AFBC85.8020500@maine.edu>
	<45AFFE72.8070709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AFFE72.8070709@tmr.com> (Bill Davidsen's message of "18 Jan 2007 23:08:22 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Steve Cousins <steve.cousins@maine.edu>, Sevrin Robstad <quackyo@start.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18 Jan 2007, Bill Davidsen spake thusly:
> ) Steve Cousins wrote:
>> time dd if=/dev/zero of=/mount-point/test.dat bs=1024k count=1024
> That doesn't give valid (repeatable) results due to caching issues. Go
> back to the thread I started on RAID-5 write, and see my results. More
> important, the way I got rid of the cache effects (beside an unloaded
> systems) was:
>  sync; time bash -c "dd if=/dev/zero bs=1024k count=2048 of=/mnt/point/file; sync"
> I empty the cache, then time the dd including the sync at the
> end. Results are far more repeatable.

Recent versions of dd have `oflag=direct' as well, to open the output
with O_DIRECT. (I'm not sure what the state of O_DIRECT on regular files
is though.)

-- 
`The serial comma, however, is correct and proper, and abandoning it will
surely lead to chaos, anarchy, rioting in the streets, the Terrorists
taking over, and possibly the complete collapse of Human Civilization.'
