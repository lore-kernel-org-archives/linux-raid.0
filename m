From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Adding a new mirror disk to RAID1 configuration
Date: Fri, 9 Jul 2004 15:29:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407091929.i69JTj320289@watkins-home.com>
References: <200407092036.01344.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407092036.01344.maarten@ultratux.net>
To: 'maarten van den Berg' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I agree with you about tapes!  For 5+ years now I have been expecting
someone to build a jukebox that uses disk drives, not tapes.  Today you can
buy jukesboxes that store tapes, optical media, cds, dvds, ...  But not hard
disks.  And like you said, a hard disk cost less than a tape with the same
capacity.  I also think the shelf life of a hard disk is longer than a tape.
And, seek time!  Hard disks are so much faster!

Back to RAID1...
I would not want my array to be in a constant bad state.  If I wanted to be
able to clone drives as you do, I would configure for 3 drives and have 3
drives so the array was in a good state.  The 3rd drive would be the clone.
Pull it when needed, then replace it.

Or, if I ever upgrade from kernel 2.4, I would use
mdadm --grow /dev/md0 --raid-disks 3
Add the drive to clone to, then back to normal.
mdadm --grow /dev/md0 --raid-disks 2
(Thanks Neil!)
Oops, not sure you can decrease the number!

Feature request!
Someone add a shrink option.
mdadm --shrink /dev/md0 --raid-disks 2
Or does --grow allow you to decrease the number?
The name would imply no.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of maarten van den Berg
Sent: Friday, July 09, 2004 2:36 PM
To: linux-raid@vger.kernel.org
Subject: Re: Adding a new mirror disk to RAID1 configuration

On Friday 09 July 2004 07:09, Guy wrote:
> My guess is you configured the RAID1 array as having 1 disk.  Now if you
> add more disks to it, they are spares.  You should have configured the
> array as having 2 disks, with 1 missing.  Then when you add a disk, it
will
> re-build to it.

What I do is even more ahead-thinking; I define a raid1 set with several 
missing drives as a rule. So I make a three- or even four disk array, with 
just two drives active (or just one). That way, you never run out of slots 
for extra drives. This stems from the fact that I used the raid toolkit to 
make clones of servers for a customer. Add a drive, let it sync, take it
out, 
put it in a new system with a blank disk and hey presto, another webserver.
:-)
I talked that customer into deploying three mirrored drives per server
anyway, 
seen that modern IDE drives are not as dependable as they used to be and
that 
the cost vs annoyment (read: downtime) -factor certainly warranted using 
three drives per system.   They quickly agreed, too.

> Read about raidreconf.  Google it, if needed!  It may allow you to modify
a
> RAID1 array.  I know it allows you to add a disk to a RAID5 array, but
> don't know about RAID1.  I have never used this tool.

Neither have I.  I'd gladly use it cause I have an 99.9999% full raid5 400GB

system here, but the off-chance that it kills all my data, which certainly 
isn't backed up anywhere NEAR complete keeps me from that.
How do you backup 400G ?  Not [easily] with DVD's, that's for sure.
And my DDS3 streamer (12GB native) could theoretically do it, but that would

take an immense amount of work and planning... even then, it would take a 
whopping 30+ tapes, so that basically kills several entire weekends...

In the meantime, I tend to just backup "important" stuff on DVD-R, have an 
extra spare disk in the array and just cross my fingers while waiting to 
build an entirely new 1TB array somewhere in the fall.
Maybe I should be more daring but I just can't run that risk...  and DLT is 
prohibitively expensive (even the tape media itself are _more_ expensive
than 
an equivalent hdd is and I'm not even talking about the drive itself yet.)
Buying an entire second raid set of disks and burying them in a fireproof
safe 
would be less expensive, and I AM including the price of the safe itself
too.

Maarten

> Guy
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Luke Reeves
> Sent: Friday, July 09, 2004 12:55 AM
> To: linux-raid@vger.kernel.org
> Subject: Adding a new mirror disk to RAID1 configuration
>
> I have a system with two 40GB drives, and the first drive (hda) is setup
>   under an md device with RAID1 driving it.  I'm trying to now make the
> second disk, hdc, a mirror of the first.  When I try to add it using
> mdadm the second disk becomes a spare and no synchronization is done.
> Is there any way to add the second disk directly as a mirror?  Thanks.
>
> 	Luke Reeves
> 	http://www.neuro-tech.net/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

