From: Neil Brown <neilb@suse.de>
Subject: Re: Request on RAID10
Date: Tue, 29 Jun 2010 16:53:27 +1000
Message-ID: <20100629165327.0a05a619@notabene.brown>
References: <loom.20100626T184818-212@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20100626T184818-212@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: koti <satha_koti@yahoo.co.in>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 26 Jun 2010 16:56:33 +0000 (UTC)
koti <satha_koti@yahoo.co.in> wrote:

> Hi Everyone,
> 
> We created RAID10 array on 4 disks (physically we had 3 1TB disks as test case
> we created 350GB partitions). We got a hang while we are doing the following:
> 1) remove the disk and add this again. Doing this in while loop.
> 2) While doing the above, simultaneously read and write on the same array.
> 
> At some point of time the recovery going to hang, then the array was not
> operational, we are using kernel 2.6.27.
> 
> I am new to use the RAID 10 array. Is this scenario was correct? if it is then
> what might be the problem, can any body suggest me and direct in proper way. It
> is very much useful for proceed further on this.

Hi Koti,
 it looks like you might have found and interesting bug.  Some sort of race
 around shutdown or startup.

 It would be very helpful if you could post some details about the exact
 situation when the system has hung.

 cat /proc/mdstat

 would be helpful (if that doesn't hang), and

 echo t > /proc/sysrq-trigger

 then collect the trace backs that went to the kernel logs and post them.

Thanks,
NeilBrown

