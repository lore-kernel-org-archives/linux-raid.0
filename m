From: Nathan Dietsch <njd@ndietsch.com>
Subject: Re: RAID5 crash and burn
Date: Mon, 01 Nov 2004 00:54:20 +1100
Message-ID: <4184EE8C.2020408@ndietsch.com>
References: <1430.63.204.219.3.1099198742.squirrel@63.204.219.3>    <200410310518.i9V5ION22004@www.watkins-home.com> <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1867.63.204.219.3.1099216777.squirrel@63.204.219.3>
Sender: linux-raid-owner@vger.kernel.org
To: coreyfro@coreyfro.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Corey,

coreyfro@coreyfro.com wrote:

>Ahhhhhh... doesn't use the raidtab... nothing needs raidtab anymore... i
>guess its time i got with the program...
>
>About swap failing, would there be much of a performence hit if i mirrored
>swap?  
>  
>
 From what I read earlier in the thread, you already have a swap 
partition on software RAID5, so how would going to RAID1 hurt performance.?
With swap on RAID5 -- unless you are paging very heavily (enough for a 
full-stripe write) -- it seems you would go into Read-Modify-Write 
anyway and this will hurt ... badly.

Mirroring swap is a good idea to avoid crashes as Guy suggests.
If you are seriously considering the performance implications of RAID1 
vs RAID5 for swap, you are already done for performance wise.

Personally I would not consider software RAID5 suitable for tasks which 
require performance. An exception would be for heavy I/O that causes 
full-stripe writes, in which case you would probably get a win out of 
the extra disks.

I hope this helps.

Kind Regards,

Nathan Dietsch
