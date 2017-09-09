From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 19:52:19 +0100
Message-ID: <6b7cbee4-562b-f127-77d8-01542f44d396@youngman.org.uk>
References: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
 <e48c2cae-dd3a-f854-0030-8e2892fa183d@youngman.org.uk>
 <20170909183701.75e7f6a36gac3rsc@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170909183701.75e7f6a36gac3rsc@merlins.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/17 19:37, Marc MERLIN wrote:
> On Sat, Sep 09, 2017 at 07:26:51PM +0100, Anthony Youngman wrote:
>> But with raid 5 you can only solve for a missing/corrupt block IF you can
>> tell the system which one is messed up. Btrfs is telling you that the data
>> is fine, so you know it's the parity, and raid 5 can fix that for you.
> 
> Thanks for confirming my understanding. I just wasn't 100% sure if md
> now had extra checksums that would not allow you to reconstruct corrupt
> data but would tell you which block was corrupted (i.e. not like parity
> where you can actually rebuild, but enough to say "yes, this one doesn't
> add up").
> 
No, it's basic maths. Remember solving simultaneous equations at school? 
For every unknown you need to solve you need one extra piece of 
information - if you have three unknowns a, b, and c, then you need four 
non-equivalent equations W, X, Y and Z in order to work out what a, b 
and c actually are. Raid 5 only has one extra piece of info, so it can 
only solve for one unknown.

md does have "extra checksums" as you phrase it, but that's just another 
name for parity :-) raid-5 is one checksum, raid-6 is two, and we may 
get three checksums, which I have been told might be called raid-7. Just 
needs someone to decide to sit down and write it.

Cheers,
Wol
