From: "Wilson Wilson" <wilson150@gmail.com>
Subject: Re: Raid5 software problems after loosing 4 disks for 48 hours
Date: Sat, 17 Jun 2006 13:24:55 +0100
Message-ID: <7c9ce5050606170524l54f2b6i75e3472d313933b0@mail.gmail.com>
References: <7c9ce5050606151659y219947e1g9f9034982d81221b@mail.gmail.com>
	 <17554.1920.421692.780276@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17554.1920.421692.780276@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil great stuff, its online now!!!

I followed your 2nd suggestion and ran mdadm --create /dev/md0 -f -l5
-n15 -c32  /dev/sd[bcdefghijklmnop]1 , after 8 hours we reached 99.9%
and some errors appeared on sdh1 which was then kicked from archive
but it was fully online.

Ill see if any further errors are reported on sdh, but in the meantime
I hotadded it back into the array which was successful.

To my surprise a full fsck reported a clean volume.

I am still unsure how this raid5 volume was partially readable with 4
disks missing.  My understanding each file is written across all disks
apart from one, which is used for CRC.  So if 2 disks are offline the
whole thing should be unreadable.

Once again thanks for your help


On 6/16/06, Neil Brown <neilb@suse.de> wrote:
> On Friday June 16, wilson150@gmail.com wrote:
> >
> > And is there a way if more then 1 disks goes offline, for the whole
> > array to be taken offline? My understanding of raid5 is loose 1+ disks
> > and nothing on the raid would be readable. this is not the case here.
> >
>
> Nothing will be writable, but some blocks might be readable.
>
>
> > All the disks are online now, what do I need to do to rebuild the array?
>
> Have you tried
>  mdadm --assemble --force /dev/md0 /dev/sd[bcdefghijklmnop]1
> ??
> Actually, it occurs to me that that might not do the best thing if 4
> drives disappeared at exactly the same time (though it is unlikely
> that you would notice)
> You should probably use
>  mdadm --create /dev/md0 -f -l5 -n15 -c32  /dev/sd[bcdefghijklmnop]1
> This is assuming that  e,f,g,h were in that order in the array before
> they died.
> The '-f' is quite important - it tells mdadm not recover a spare, but
> to resync the parity blocks.
>
> NeilBrown
>
