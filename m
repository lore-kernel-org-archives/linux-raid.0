From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: how to which to bigger disk (md can do it?)
Date: Sun, 16 Nov 2003 15:31:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031116133137.GF25876@hvs.envisage.co.za>
References: <3FB75992.3020608@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FB75992.3020608@bnap.hu>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 16, 2003 at 12:03:46PM +0100, Farkas Levente wrote:
> hi,
> we've got a server with 3ware 7500-8 and 8 pieces of 120 GB maxtor hd 
> and software raid-5. the 1TB disk is running out of the space so we 

Are you sure about the Software RAID on this 3ware adapater?? I was
under the impression it's a HW Raid adapter?
(I have a preference to HW RAID if available...)

> - put the 8 disk to another server and run rsync through two gigabit 
> ethernet card. but it can takes more than a day to sync about 800GB.

You could do this initially during the week before the swapout, and then
just update it  before the swap out. Something te note, if it's lots of files,
I'd advise to run multiple rsyncs over smaller directories, as it speeds
up the rsync processing alot.

> - switch the disks one-by-one in the current server and leave linux's 
> software raid to sync the data. in this case we only have to stop the 
> system a few mintues per day and takes 8 days, but continous operation. 
> does it possible? after I put all new hard disk the totel capacity will 
> be (8-1)*200 GB or it will remain (8-1)*120 GB? since during the disk 
> switch the total space is the smallest hd's*(n-1), but what happens when 
> I put the last 200GB disk?

If it's SW raid, it'll be based on the partitions, so you'll have to create the
partitions bigger than the current 120GB partitions. Then after the last disk,
the size would be the bigger size, however you'll then need to run a growfs
(or similar) for your filesystem to expand it to the bigger size.

Fr HW Raid, it'll depend on the controller.

Hendrik
