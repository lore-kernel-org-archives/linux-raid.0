From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: An extensible superblock
Date: Tue, 11 Jan 2011 13:52:39 -0600
Message-ID: <01BF00A4-AC7E-4071-9FC1-16F123ED2500@redhat.com>
References: <4D2C9FB7.6050806@gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2C9FB7.6050806@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Would it make sense for me to bring up my idea of having the metadata  
and data kept separately here?  (Perhaps not, as this is related to  
the device-mapper/MD integration work; but I'll post it for what it is  
worth.)

http://marc.info/?l=linux-raid&m=129434759113635&w=2

  brassow

On Jan 11, 2011, at 12:21 PM, Kent Overstreet wrote:

> This is, in a roundabout way, an extension of some stuff I was  
> talking to Neil about - but this is slightly more wild speculation.
>
> Background: bcache
> http://bcache.evilpiepirate.org
>
> Bcache currently caches block devices transparently; this is useful  
> but unsafe. It needs a superblock for the backing device, and it  
> turns out what it needs out of a superblock is not very dissimilar  
> from what md does, so I've been thinking about how to best go about  
> using md.
>
> Well, the annoying thing about that for the end user is that if you  
> want to cache your hard drive safely, you have to plan ahead...  
> there's no technical reason you shouldn't be able to add a cache to  
> the filesystem you've already got but you need a place to put the  
> superblock.
>
> The exact same problem exists with raid: you installed to a single  
> disk, you decide you want to mirror it - there's no good way of  
> doing that. There's three different solutions I know of (make a  
> degraded raid1 on the new disk, copy everything over; use a 1.2  
> superblock - if it fits; or when you first install force create a  
> single disk raid1). They work but they're hacks, it'd be nice to  
> have something better.
>
> The last solution - start with a raid superblock - would be  
> particularly nice if there was an explicit "noop" raid level; you  
> could quite conceivable grow from a single disk to a raid6, online.  
> Trouble is, you could add a cache, create a raid, but not both.
>
> Well, not without a new superblock, which is why I prefaced this by  
> calling it wild speculation - I really like this solution but it'd  
> be a fair amount of work.
>
> Change the superblock so it describes a tree structure:
> Leaf nodes correspond to component devices. Thus, a superblock that  
> describes an array with only one component would be a noop superblock.
>
> Then, interior nodes correspond to raid arrays or cache sets. Much  
> of what's in the start of the version 1 superblock would be here.
>
> Anyways, once you've got that you can have a standard superblock  
> that you use for everything, and you can safely and easily  
> transition to whatever you might want to in the future.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

