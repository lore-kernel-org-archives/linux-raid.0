From: Nix <nix@esperi.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Fri, 05 May 2017 23:14:11 +0100
Message-ID: <87zier9cjw.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <22796.57128.627832.878830@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22796.57128.627832.878830@tree.ty.sabi.co.uk> (Peter Grandi's
        message of "Fri, 5 May 2017 21:23:04 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 5 May 2017, Peter Grandi stated:

>> This feature still adds value (see below).
>
> It adds value if one underestimates typical disk drive failure
> modes.  It is quite irritating even for me that a drive with way
> less than 1% bad blocks becomes effectively unusable, but long
> experience tells me that once a drive starts to grow defects to the
> point that manufacturer spare sectors run out there is usually a
> reason for it and sooner than later it will be almost completely
> unusable.

Quite. In my experience, if there are that many bad blocks on rotational
storage, it generally means either that a head has died or that the disk
surface is damaged. If the disk surface is damaged to that degree, there
will be crap flying around inside the drive at very high speed, abrading
the drive surface further with every passing minute. Such a drive is
walking dead. Get any surviving data off now and throw it away with
extreme prejudice, possibly pulling it apart first to gawp at the
horribleness that is all that remains of your disk surfaces. As for the
dead-head case, the question is whether whatever killed the head
produced debris. If it did, you're back at the previous problem, and if
it's electronic failure, frankly the whole drive is untrustworthy IMHO.
(There *are* other possibilities: catastrophically buggy drive firmware,
for instance -- but in such cases the drive is *also* walking dead.)

-- 
NULL && (void)
