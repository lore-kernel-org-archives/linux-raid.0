From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Bit-Rot
Date: Fri, 3 Mar 2017 22:16:41 +0000
Message-ID: <dce0bbfd-ea6b-4ed8-668a-c883c2380aca@youngman.org.uk>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
 <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 03/03/17 21:54, Gandalf Corvotempesta wrote:
> 2017-03-03 22:41 GMT+01:00 Anthony Youngman <antlists@youngman.org.uk>:
>> Isn't that what raid 5 does?
>
> nothing to do with raid-5
>
>> Actually, iirc, it doesn't read every stripe and check parity on a read,
>> because it would clobber performance. But I guess you could have a switch to
>> turn it on. It's unlikely to achieve anything.
>>
>> Barring bugs in the firmware, it's pretty near 100% that a drive will either
>> return what was written, or return a read error. Drives don't return dud
>> data, they have quite a lot of error correction built in.
>
> This is wrong.
> Sometimes drives return data differently from what was stored, or,
> store data differently from the original.
> In this case, if real data is "1" and you store "0", when you read
> "0", no read error is made, but data is still corrupted.

Do you have any figures? I didn't say it can't happen, I just said it 
was very unlikely.
>
> With a bit-rot prevention this could be fixed, you checksum "1" from
> the source, write that to disks and if you read back "0", the checksum
> would be invalid.

Or you just read the raid5 parity (which I don't think, by default, is 
what happens). That IS your checksum. So if you think the performance 
hit is worth it, write the code to add it, and turn it on. Not only will 
it detect a bit-flip, but it will tell you which bit flipped, and let 
you correct it.
>
> This is what ZFS does. This is what Gluster does. This is what BRTFS does.
> Adding this in mdadm could be an interesting feature.
>
Well, seeing as I understand btrfs doesn't do raid5, only raid1, then of 
course it needs some way of detecting whether a mirror is corrupt. I 
don't know about gluster or ZFS. (I believe raid5/btrfs is currently 
experimental, and dangerous.)

But the question remains - is the effort worth it?

Can I refer you to a very interesting article on LWN? About git, which 
assumes that "if hash(A) == hash(B) then A == B". And how that was 
actually MORE accurate than "if (memcmp( A, B) == true) then A == B".

Cheers,
Wol
