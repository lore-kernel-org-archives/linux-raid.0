From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Bit-Rot
Date: Fri, 3 Mar 2017 22:54:00 +0100
Message-ID: <CAJH6TXimNQ8raxBCT=aLhzLzRnbMh8adcF21BrOqp6G-cajLpw@mail.gmail.com>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
 <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-03-03 22:41 GMT+01:00 Anthony Youngman <antlists@youngman.org.uk>:
> Isn't that what raid 5 does?

nothing to do with raid-5

> Actually, iirc, it doesn't read every stripe and check parity on a read,
> because it would clobber performance. But I guess you could have a switch to
> turn it on. It's unlikely to achieve anything.
>
> Barring bugs in the firmware, it's pretty near 100% that a drive will either
> return what was written, or return a read error. Drives don't return dud
> data, they have quite a lot of error correction built in.

This is wrong.
Sometimes drives return data differently from what was stored, or,
store data differently from the original.
In this case, if real data is "1" and you store "0", when you read
"0", no read error is made, but data is still corrupted.

With a bit-rot prevention this could be fixed, you checksum "1" from
the source, write that to disks and if you read back "0", the checksum
would be invalid.

This is what ZFS does. This is what Gluster does. This is what BRTFS does.
Adding this in mdadm could be an interesting feature.
