From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH 1/1] md: drivers/md/unroll.pl replaced with awk analog
Date: Tue, 6 Oct 2009 16:03:50 +1100
Message-ID: <f2dbd45db6d92b291359456c98cf1f35.squirrel@neil.brown.name>
References: <4aca1863.0a1ad00a.33bf.1017@mx.google.com>
    <200910051630.51039.rob@landley.net> <4ACA87DA.7000607@panix.com>
    <200910052344.46809.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910052344.46809.rob@landley.net>
Sender: linux-raid-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: berk walker <berk@panix.com>, Vladimir Dronnikov <dronnikov@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, October 6, 2009 3:44 pm, Rob Landley wrote:
> On Monday 05 October 2009 18:57:14 berk walker wrote:
>> Rob Landley wrote:
>> > On Monday 05 October 2009 11:01:39 Vladimir Dronnikov wrote:
>> >> From: Vladimir Dronnikov <dronnikov@gmail.com>
>> >>
>> >> drivers/md/unroll.pl replaced by awk script to drop build-time
>> >> dependency on perl
>> >>
>> >> Signed-off-by: Vladimir Dronnikov <dronnikov@gmail.com>
>> >
>> > Acked-by: Rob Landley <rob@landley.net>
>> >
>> > We already discussed this on another mailing list, thread starts at:
>> >
>> > http://lists.impactlinux.com/pipermail/firmware-impactlinux.com/2009-Octo
>> >ber/000328.html
>> >
>> > I've added this as patch #4 in the perl removal series I've submitted
>> > during the last few merge windows.
>> >
>> > Thanks,
>> >
>> > Rob
>>
>> Why is perl being removed? [I know that I have missed a lot]
>> berk-
>
> Before 2.6.25 the kernel build had never used perl,

Uhhhmmmm.  md has used perl for creating some C files since
RAID6 was added, which is before the dawn of git.

So I don't think this statement is true.

I'm have to remove the perl dependency though.

NeilBrown



>    and the first perl
> removal
> patches were submitted for 2.6.26, so the real question is "why was it
> added,
> and was it worth it?"
>
> There was a long thread on an earlier submission of the patches, which
> Alan
> Cox concluded (as far as I'm concerned, unless Linus, Andrew Morton, or
> maybe
> Al Viro want to weigh in) with this post:
>
>   http://lkml.indiana.edu/hypermail/linux/kernel/0901.1/02108.html
>
> Archives are linked from there, you might have to check adjacent weeks
> too.
>
> Rob
> --
> Latency is more important than throughput. It's that simple. - Linus
> Torvalds
>

