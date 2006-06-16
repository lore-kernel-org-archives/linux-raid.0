From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 software problems after loosing 4 disks for 48 hours
Date: Fri, 16 Jun 2006 11:21:04 +1000
Message-ID: <17554.1920.421692.780276@cse.unsw.edu.au>
References: <7c9ce5050606151659y219947e1g9f9034982d81221b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wilson Wilson on Friday June 16
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Wilson <wilson150@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 16, wilson150@gmail.com wrote:
> 
> And is there a way if more then 1 disks goes offline, for the whole
> array to be taken offline? My understanding of raid5 is loose 1+ disks
> and nothing on the raid would be readable. this is not the case here.
> 

Nothing will be writable, but some blocks might be readable.


> All the disks are online now, what do I need to do to rebuild the array?

Have you tried
  mdadm --assemble --force /dev/md0 /dev/sd[bcdefghijklmnop]1
??
Actually, it occurs to me that that might not do the best thing if 4
drives disappeared at exactly the same time (though it is unlikely
that you would notice)
You should probably use
 mdadm --create /dev/md0 -f -l5 -n15 -c32  /dev/sd[bcdefghijklmnop]1
This is assuming that  e,f,g,h were in that order in the array before
they died.
The '-f' is quite important - it tells mdadm not recover a spare, but
to resync the parity blocks.

NeilBrown
