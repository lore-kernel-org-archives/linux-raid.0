From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: RAID1 and data safety?
Date: Tue, 22 Mar 2005 09:48:57 +0100
Message-ID: <62b0912f05032200484c21c265@mail.gmail.com>
References: <62b0912f05031601131b8daf4a@mail.gmail.com>
	 <16959.18991.327224.545186@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <16959.18991.327224.545186@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>> Is there any way to tell MD to do verify-on-write and
>> read-from-all-disks on a RAID1 array?
>
> No.
> I would have thought that modern disk drives did some sort of
> verify-on-write, else how would they detect write errors, and they are
> certainly in the best place to do verify-on-write.

Really?  My guess was that they wouldn't, because it would lead to
less performance.
And that's why read errors crop up at read time.

> Doing it at the md level would be problematic as you would have to
> ensure that you really were reading from the media and not from some
> cache somewhere in the data path.  I doubt it would be a mechanism
> that would actually increase confidence in the safety of the data.

Hmm.  Could hack it by reading / writing blocks larger than the cache.  Ugly.

> Imagine a filesystem that could access multiple devices, and where it
> kept index information it didn't just keep one block address, but
> rather kept two block address, each on different devices, and a strong
> checksum of the data block.  This would allow much the same robustness
> as read-from-all-drives and much lower overhead.

As in, "if the checksum fails, try loading the data blocks [again]
from the other device"?
Not sure why a checksum of X data blocks should be cheaper
performance-wise than a comparison between X data blocks, but I can
see the point in that you only have to load the data once and check
the checksum.  Not quite the same security, but almost.

> In summary:
>  - you cannot do it now.
>  - I don't think md is at the right level to solve these sort of problems.
>    I think a filesystem could do it much better. (I'm working on a
>    filesystem .... slowly...)
>  - read-from-all-disks might get implemented one day. verify-on-write
>    is much less likely.
> 
>> Apologies if the answer is in the docs.
> 
> It isn't.  But it is in the list archives now....

Thanks! :-)

(Guess I'll drop the idea for the time being...)
