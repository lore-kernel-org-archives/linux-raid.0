From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 13:22:52 -0800
Message-ID: <20180209212252.GN9565@merlins.org>
References: <20180209192928.vliiwkv6q76jf6jp@merlins.org> <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org> <20180209202958.6mieeomu5of45rjf@merlins.org> <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de> <20180206181416.amo6geclrvc6ylrf@merlins.org> <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de> <20180209192928.vliiwkv6q76jf6jp@merlins.org> <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org> <20180209202958.6mieeomu5of45rjf@merlins.org> <5947e803-b1e8-b530-4935-df126f867213@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de> <5947e803-b1e8-b530-4935-df126f867213@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 09, 2018 at 03:44:56PM -0500, Phil Turmel wrote:
> > myth:~# mdadm -E /dev/sdd e f g h all return
> > /dev/sdd:
> >    MBR Magic : aa55
> > Partition[0] :   4294967295 sectors at            1 (type ee)
> 
> This means nothing.  Please run mdadm -E on the *member devices*.  That
> means include the partition number if you are using partitions.  See the
> output of mdadm -D /dev/mdX for an array's list of *members*.
 
Ooops, I knew better, sorry about that (I use --examine usually)

As you guessed, there it is:
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.

So it knows about the bad blocks, skips over them during check/rewrite and
that's why they never got rewritten.
I can see why this could be helpful in some way, but yeah, that confused me
until now. Thanks for pointing that out to me.

> > I think it's worse here. Read errors are not being cleared by block rewrites?
> > Those are brand "new" (but really remanufactured) drives. 
> > So far I'm not liking what I'm seeing and I'm very close to just
> > returning them all and getting some less dodgy ones.
> 
> How do you know that these sectors have been re-written?  Let me repeat:
> MD will *not* write to blocks that it has recorded as bad in *its* bad
> block list, and doesn't even read non-data-area blocks during a check.
 
Right, got it.

> > Sad because the last set of 5 I got from a similar source, have worked
> > beautifully.
> 
> I'm not convinced these drives aren't working beautifully.

Would you say it's acceptable for a drive nowadays to come with pending sectors 
as soon as you use it?
Yes, I understand I can get them re-allocated and once too many get reallocated, 
things get incrementally bad, but my bar so far as been that by the time a drive
is starting to re-allocate sectors, I should start watching it closely.
If it does this out of the box, then it shouldn't have passed QA and been shipped
to me to start with.
Maybe it's the problem of how many dead pixels are acceptable on a 4K LCD?

> > myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> > /dev/sdh is apparently in use by the system; badblocks forced anyway.
> 
> This should have been a hint that you shouldn't be using the badblocks
> utility on a running array's devices.
 
I knew I was doing that, we already established that those blocks are not being
used by the array itself because they're in the md bad block skip list, no?
But ok, point taken, bad practise, I'll stop the array first next time.

On Fri, Feb 09, 2018 at 09:52:38PM +0100, Kay Diederichs wrote:
> > From block 1287409400 to 1287409599
> > Checking for bad blocks (non-destructive read-write test)
> > Testing with random pattern: 1287409520ne, 0:14 elapsed. (0/0/0 errors)
> > 1287409521ne, 0:18 elapsed. (1/0/0 errors)
> > 1287409522ne, 0:23 elapsed. (2/0/0 errors)
> > 1287409523ne, 0:27 elapsed. (3/0/0 errors)
> > 1287409524ne, 0:31 elapsed. (4/0/0 errors)
> > 1287409525ne, 0:36 elapsed. (5/0/0 errors)
> > 1287409526ne, 0:40 elapsed. (6/0/0 errors)
> > 1287409527ne, 0:44 elapsed. (7/0/0 errors)
> > done                                                 
> > Pass completed, 8 bad blocks found. (8/0/0 errors)
> 
> What you write about the result of
> badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> is the expected behavior. -n means that it will _not_ write sectors that
> it cannot read (because that would remove the possibility that data from
> these sectors could be recovered by more tries).
> 
> As I wrote, you have to use the -w option instead of -n, and use x and y
> of 1287409527 1287409520

Right. Just had a very short night, so I'm not doing my best thinking right now :)

myth:~# badblocks -fsvwb512 /dev/sdh 1287409527 1287409520
/dev/sdh is apparently in use by the system; badblocks forced anyway.
Checking for bad blocks in read-write mode
From block 1287409520 to 1287409527
Testing with pattern 0xaa: done                                                 
Reading and comparing: done                                                 
Testing with pattern 0x55: done                                                 
Reading and comparing: done                                                 
Testing with pattern 0xff: done                                                 
Reading and comparing: done                                                 
Testing with pattern 0x00: done                                                 
Reading and comparing: done                                                 
Pass completed, 0 bad blocks found. (0/0/0 errors)

I'm a bit confused as to why bad blocks needs to work in reverse sector
order, but it worked.

Before:
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0                               
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       2    
After:
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       1

So, that fixed one sector, and somehow the drive decided it didn't need to be re-allocated.

Interesting. I figured once a sector went pending once, it would not actually be re-used and 
be remapped on the next write. Seems like it didn't happen here.

Either way, thanks all for you help, let me poke at it a bit more.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
