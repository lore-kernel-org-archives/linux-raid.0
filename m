From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Creating RAID5 with four devices and end up with 5 (one removed and one spare). Why?
Date: Mon, 3 Mar 2008 10:29:58 +0100
Message-ID: <47CBC516.5050904@gmail.com>
References: <47CBBD11.4020501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080303091952.GA1125@cthulhu.home.robinhill.me.uk>
References: <20080303091952.GA1125@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for your reply Robin!

Robin Hill wrote:
>> So what i don't get is:
>>
>> 1. Why is mdadm --examine listing "3     3       0        0        3   
>> faulty removed" and telling me I have a failed device?
>> 2. Why is one of the actual disks (sdf) used as a spare, even though I 
>> didn't ask for it?
>>
>> Thanks for any tips or insights which may put me on the right track :)
>>
> This is perfectly normal (and explained in the manual page) - the RAID5
> array is created in an initially degraded state, then rebuilt.  This
> means the array can be available for use immediately, with the rebuild
> taking place in the background.  You'll need to run 'mdadm -w /dev/md0'
> to force the array into read-write mode (it's currently started in
> auto-read-only mode) and the resync will then begin.

I had a suspicion this was the case for question number two -- why one 
of the disks initially are marked as spares. Good to have that cleared up!

But does that explain why mdadm believes I have another disk, a fifth 
disk, that has been removed? The ID numbers of the real disks are 
0,1,2,4 but I would expect 0,1,2,3:

        Number   Major   Minor   RaidDevice State
this      1       8       49        1      active sync   /dev/sdd1

     0     0       8       33        0      active sync   /dev/sdc1
     1     1       8       49        1      active sync   /dev/sdd1
     2     2       8       65        2      active sync   /dev/sde1
     3     3       0        0        3      faulty removed <-- What's up?
     4     4       8       81        4      spare   /dev/sdf1

Thanks!

Tor Arne

