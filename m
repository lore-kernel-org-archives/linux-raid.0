From: david@lang.hm
Subject: Re: limits on raid
Date: Fri, 22 Jun 2007 02:51:15 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706220235590.9657@asgard.lang.hm>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <46756BE2.7010401@tmr.com>
 <467B03C1.50809@tmr.com> <18043.13037.40956.366334@notabene.brown>
 <467B840F.4080402@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <467B840F.4080402@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jun 2007, David Greaves wrote:

> That's not a bad thing - until you look at the complexity it brings - and 
> then consider the impact and exceptions when you do, eg hardware 
> acceleration? md information fed up to the fs layer for xfs? simple long term 
> maintenance?
>
> Often these problems are well worth the benefits of the feature.
>
> I _wonder_ if this is one where the right thing is to "just say no" :)

In this case I think the advantages of a higher level system knowing what 
efficiant blocks to do writes/reads in can potentially be a HUGE 
advantage.

if the uppper levels know that you ahve a 6 disk raid 6 array with a 64K 
chunk size then reads and writes in 256k chunks (aligned) should be able 
to be done at basicly the speed of a 4 disk raid 0 array.

what's even more impressive is that this could be done even if the array 
is degraded (if you know the drives have failed you don't even try to read 
from them and you only have to reconstruct the missing info once per 
stripe)

the current approach doesn't give the upper levels any chance to operate 
in this mode, they just don't have enough information to do so.

the part about wanting to know raid 0 chunk size so that the upper layers 
can be sure that data that's supposed to be redundant is on seperate 
drives is also possible

storage technology is headed in the direction of having the system do more 
and more of the layout decisions, and re-stripe the array as conditions 
change (similar to what md can already do with enlarging raid5/6 arrays) 
but unless you want to eventually put all that decision logic into the md 
layer you should make it possible for other layers to make queries to find 
out what's what and then they can give directions for what they want to 
have happen.

so for several reasons I don't see this as something that's deserving of 
an atomatic 'no'

David Lang
