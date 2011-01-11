From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: An extensible superblock
Date: Tue, 11 Jan 2011 12:02:18 -0800
Message-ID: <4D2CB74A.6000905@gmail.com>
References: <4D2C9FB7.6050806@gmail.com> <01BF00A4-AC7E-4071-9FC1-16F123ED2500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01BF00A4-AC7E-4071-9FC1-16F123ED2500@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 01/11/2011 11:52 AM, Jonathan Brassow wrote:
> Would it make sense for me to bring up my idea of having the metadata
> and data kept separately here? (Perhaps not, as this is related to the
> device-mapper/MD integration work; but I'll post it for what it is worth.)

I firmly believe that such schemes - and the idea of metadata in 
userspace in general - may be profoundly useful and ought to be 
supported to the extent that they are useful, but they shouldn't get in 
the way of having something simple and consistent. Emphasis on simple.

Hell, external metadata is basically what bcache does today. But if your 
metadata isn't stored with the data it's describing, then... well, it's 
not really correct but the way I think of it is whether the data is self 
describing or not.

If you've got a filesystem with a cache on another device, then it's not 
just a filesystem, it's a filesystem with a cache on another device; 
using it as such is critical for consistency, and if you leave that 
superblock out then there's no way you can tell them (a plain filesystem 
vs. a filesystem with a cache) if you haven't already seen the metadata.

N.B.:

Just because you have a md superblock doesn't mean you can't put all the 
important things somewhere else, it's just absolutely critical that you 
have some way of noting that in your superblock. Else you can never know 
if you have a correct/consistent view of your data.

>
> http://marc.info/?l=linux-raid&m=129434759113635&w=2
>
> brassow
>
> On Jan 11, 2011, at 12:21 PM, Kent Overstreet wrote:
>
>> This is, in a roundabout way, an extension of some stuff I was talking
>> to Neil about - but this is slightly more wild speculation.
>>
>> Background: bcache
>> http://bcache.evilpiepirate.org
>>
>> Bcache currently caches block devices transparently; this is useful
>> but unsafe. It needs a superblock for the backing device, and it turns
>> out what it needs out of a superblock is not very dissimilar from what
>> md does, so I've been thinking about how to best go about using md.
>>
>> Well, the annoying thing about that for the end user is that if you
>> want to cache your hard drive safely, you have to plan ahead...
>> there's no technical reason you shouldn't be able to add a cache to
>> the filesystem you've already got but you need a place to put the
>> superblock.
>>
>> The exact same problem exists with raid: you installed to a single
>> disk, you decide you want to mirror it - there's no good way of doing
>> that. There's three different solutions I know of (make a degraded
>> raid1 on the new disk, copy everything over; use a 1.2 superblock - if
>> it fits; or when you first install force create a single disk raid1).
>> They work but they're hacks, it'd be nice to have something better.
>>
>> The last solution - start with a raid superblock - would be
>> particularly nice if there was an explicit "noop" raid level; you
>> could quite conceivable grow from a single disk to a raid6, online.
>> Trouble is, you could add a cache, create a raid, but not both.
>>
>> Well, not without a new superblock, which is why I prefaced this by
>> calling it wild speculation - I really like this solution but it'd be
>> a fair amount of work.
>>
>> Change the superblock so it describes a tree structure:
>> Leaf nodes correspond to component devices. Thus, a superblock that
>> describes an array with only one component would be a noop superblock.
>>
>> Then, interior nodes correspond to raid arrays or cache sets. Much of
>> what's in the start of the version 1 superblock would be here.
>>
>> Anyways, once you've got that you can have a standard superblock that
>> you use for everything, and you can safely and easily transition to
>> whatever you might want to in the future.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

