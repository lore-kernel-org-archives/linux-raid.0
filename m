From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Adding a new mirror disk to RAID1 configuration
Date: Fri, 9 Jul 2004 20:36:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407092036.01344.maarten@ultratux.net>
References: <200407090509.i6959W316863@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200407090509.i6959W316863@watkins-home.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 09 July 2004 07:09, Guy wrote:
> My guess is you configured the RAID1 array as having 1 disk.  Now if you
> add more disks to it, they are spares.  You should have configured the
> array as having 2 disks, with 1 missing.  Then when you add a disk, it will
> re-build to it.

What I do is even more ahead-thinking; I define a raid1 set with several 
missing drives as a rule. So I make a three- or even four disk array, with 
just two drives active (or just one). That way, you never run out of slots 
for extra drives. This stems from the fact that I used the raid toolkit to 
make clones of servers for a customer. Add a drive, let it sync, take it out, 
put it in a new system with a blank disk and hey presto, another webserver.
:-)
I talked that customer into deploying three mirrored drives per server anyway, 
seen that modern IDE drives are not as dependable as they used to be and that 
the cost vs annoyment (read: downtime) -factor certainly warranted using 
three drives per system.   They quickly agreed, too.

> Read about raidreconf.  Google it, if needed!  It may allow you to modify a
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
prohibitively expensive (even the tape media itself are _more_ expensive than 
an equivalent hdd is and I'm not even talking about the drive itself yet.)
Buying an entire second raid set of disks and burying them in a fireproof safe 
would be less expensive, and I AM including the price of the safe itself too.

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

