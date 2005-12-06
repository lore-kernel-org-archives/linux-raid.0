From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID5 resync question
Date: Tue, 6 Dec 2005 01:45:09 +0100
Message-ID: <004201c5f9fe$50cc41a0$0400a8c0@dcccs>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs> <17300.56329.638969.509384@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, December 06, 2005 1:32 AM
Subject: Re: RAID5 resync question


> On Tuesday December 6, djani22@dynamicweb.hu wrote:
> > Hello, list,
> >
> >
> > Is there a way to force the raid to skip this type of resync?
>
> Why would you want to?
> The array is 'unclean', presumably due to a system crash.  The parity
> isn't certain to be correct so your data isn't safe against a device
> failure.  You *want* this resync.

Thanks for the warning.
Yes, you have right, the system is crashed.

I know, it is some chance to leave some incorrect parity information on the
array, but may be corrected by next write.
On my system is very little dirty data, thanks to vm configuration and
*very* often flushes.
The risk is low, but the time what takes the resync is bigger problem. :-(

If i can, i want to break this resync.
And same on the fresh NEW raid5 array....

(One possible way:
in this time rebuild the array with "--force-skip-resync" option or
something similar...)

>
> If you are using 2.6.14 to later you can try turning on the
> write-intent bitmap (mdadm --grow /dev/md0 --bitmap=internal).
> That may impact write performance a bit (reports on how much would be
> appreciated) but will make this resync-after-crash much faster.

Hmm.
What does this exactly?
Changes the existing array's structure?
Need to resync? :-D
Safe with existing data?

What do you think about full external "log"?
To use some checkpoints in ext file or device to resync an array?
And the better handling of half-synced array?


Cheers,
Janos

>
> NeilBrown
>
> >
> > Every 2s: cat /proc/mdstat                              Tue Dec  6
01:28:55
> > 2005
> >
> > Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
> > [raid10] [f
> > aulty]
> > md0 : active raid5 sdb1[4] sda1[10] hds1[5] hdq1[2] hdo1[3] hdm1[8]
hdk1[6]
> > hdi1
> > [7] hde1[9] hdc1[1] hda1[0]
> >       1953583360 blocks level 5, 32k chunk, algorithm 2 [11/11]
> > [UUUUUUUUUUU]
> >       [=>...................]  resync =  6.0% (11758724/195358336)
> > finish=1216.8
> > min speed=2512K/sec
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

