From: Mike Hardy <mhardy@h3c.com>
Subject: Re: the dreaded double disk failure
Date: Thu, 13 Jan 2005 00:47:03 -0800
Message-ID: <41E63587.3090401@h3c.com>
References: <200501130835.j0D8Z5902816@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501130835.j0D8Z5902816@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks for responding, Guy - I appreciate it

Guy wrote:

> You should do something like a nightly dd of every disk!  Then you would

I have smartd set up to do a nightly short scan of all drives, and a 
weekly full scan. I may alter that to be a full scan of all drives once 
a day after this. I do test them though, and frequently

> bad block I fail the disk then overwrite the disk/partition with a dd
> command.  This causes the disk to re-map the bad block to a spare block.
> Then I test the disk with another dd read command.  Once I am sure the disk
> is good, I add it back to the array.  All of this is a real pain in the @$$.
> Some people just fail the disk, then add it back in.  They just let the
> re-sync cause the disk to re-map the bad block.  I guess I feel more
> in-control my way.

I typically just fail the disk and re-add it - but sometimes I do the 
manual fail/dd/add way. You're right its a pain in the butt, but its 
moot at this point because I've got two bad spots in one raid 5

> If raidreconf did not finish, I think you should expect major data loss!
> If raidreconf did not finish, stop here and ignore any advice below!

I wasn't terribly clear (its been a long day) - the raidreconf failure 
was on a separate machine containing my backup array. This is where my 
main array would rsync too nightly, if it weren't hosed. I gave up on it 
though (funnily enough, it got a bad sector too, sigh), and just 
re-built that array from scratch, clean, after full scans on all drives.

So my backup array is fresh and in sync and ready for data if I can get 
the data.

> You have more than 1 option.

That's a good spot to be in

> OPTION ONE:
> If you assemble the array with 1 missing disk and no spare, it will not
> attempt to re-build or re-sync.  It will just be fine until it finds the bad
> block as you said.
> 
> So, I think your plan will work.  But I think you may need to assemble 3
> times before you have all of your data!  In each case, when you determine
> which file is on a bad block, delete the file after you get a good copy,
> then the next time you will not have a read error on that file.  I think
> this is what you meant, but not sure.

That is what I meant, and this is my most safe, but most tedious option 
I think. I could do it in two restarts if I picked the right drives I 
think, but its hard to say. Either way I thought it would work, and I'll 
take this as a second on that idea.

> OPTION TWO:
> If you have an extra disk, you could use dd_rescue to make a copy of one of
> your bad disks.  This will cause corruption related to the bad block.  But
> it would get you going again.  Then assemble your array with this "new" disk
> and the other bad disk as missing.  Once you are sure your data is there you
> could add you missing disk and it will re-sync.  The re-sync should cause
> the disk to re-map the bad block.

I am out of disks, and this seems like a painful option

> OPTION THREE:
> Another idea!  Maybe risky!  It scares me!
> But if I am correct, no data loss.
> For this to work, you must not use any tools to change any data on any of
> the 8 disks!!!!!!!!!!
> No attempts to repair the disks with dd or anything!!!!!
> 
> Assemble your array with hdk1 missing.  Then add hdk1 to the array, the
> array will start to re-sync.  This re-sync should overwrite the disk with
> the same data that is all ready there.  The re-sync should re-map the bad
> block and continue until hdo1 hits its bad block.  At that time hdo1 will be
> kicked out, and the array will be down.  But hdk1 should now be good since
> the data should still be on it.  So, now assemble the array with hdo1
> missing, then add hdo1 and a re-sync will start, this should correct the bad
> block and the re-sync should finish, unless you have a third bad block.
> Each time you have a read error, just repeat the process with the disk that
> got the last read error as the missing disk, then add it to the array to
> start another re-sync.

Now that's an interesting thought. Is resync linear and monotonically 
increasing across the LBA addresses of the drives? If so, I think this 
might become the "standard" way to recover from multi-disk failures in 
raid5, if you can assume the errors are on different stripes and you 
know their locations (from smartctl, etc)

I'd love to hear Neil's take on this.

> OPTION FOUR:  (not an option)
> A standalone tool to scan the disks and repair as you suggest would be real
> cool!  It would just read test every disk until it finds a read error, then
> compute the missing data, then re-write it.  Then continue on.  It could
> also verify the parity and correct as needed.  I don't think such a tool
> exists today.

This is intriguing as a potential contribution to the pool of utilities 
out there, as I get a lot of benefit from it, and it'd be neat to put 
something back. I'm still not sure if its possible though

Thanks again, and I'll see what other people have to say
-Mike
