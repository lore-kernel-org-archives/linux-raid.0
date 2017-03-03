From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Bit-Rot
Date: Fri, 3 Mar 2017 21:41:24 +0000
Message-ID: <95588e39-f42e-54d4-e7ff-a70af51a77c1@youngman.org.uk>
References: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXgimQ9Ru58GCvaxqTZrYE9yDYh9osq2tEP_sLTfV0gQmg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/03/17 21:25, Gandalf Corvotempesta wrote:
> Hi to all
> Wouldn't be possible to add a sort of bitrot detection on mdadm?
> I know that MD is working on blocks and not files, but checksumming a
> block should still be possible.
>
> In example, if you read some blocks with dd, you can still hash the
> content and verify that on next read/consistency check

Isn't that what raid 5 does?

Actually, iirc, it doesn't read every stripe and check parity on a read, 
because it would clobber performance. But I guess you could have a 
switch to turn it on. It's unlikely to achieve anything.

Barring bugs in the firmware, it's pretty near 100% that a drive will 
either return what was written, or return a read error. Drives don't 
return dud data, they have quite a lot of error correction built in.

Cheers,
Wol
