From: Raz <raziebe@gmail.com>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Tue, 12 May 2009 19:59:49 +0300
Message-ID: <5d96567b0905120959k2910b6b9k95f7f364d167d15f@mail.gmail.com>
References: <1241300764.5607.36.camel@raz> <18951.21983.1676.992436@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18951.21983.1676.992436@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 11, 2009 at 1:31 AM, Neil Brown <neilb@suse.de> wrote:
> On Sunday May 3, raziebe@013.net wrote:
>> Neil Hello
>> The bellow is the raid0 grow code.I have decided to fix raid0 and no=
t
>> perform the transformation raid0-raid4-raid0 due to two reasons:
>> 1. raid0 zones. this patch support any zone transformations.
>> 2. Undesired dependency of raid0 over raid4 re-striping code.
>>
>> The following tests were conducted:
>> 1. various chunk sizes, 4K to 512K. ( mainly in 2.6.27 and 2.6.18 )
>> 2. regrow ( tested on 2.6.27 and 2.6.18 )
>> 3. various super blocks. 0.9 , 1, 1.1 and 1.2 ( mainly in 2.6.27 and=
 2.6.18 ).
>> 4. support assembling and mounting older raid version ( older kernel=
s and code before patch) after it was grown.
>>
>> patch passed checkpatch.pl . other than reshaping code i beautified =
the code.
>> Currently i about to pass this code to our testing team for further =
tests.
>> Other things to do:
>> 1. Speedup the reshape process.It is too slow.
>> 2. Support for non power 2^n ( page size) chunks.
>>
>> I will be thankful for your criticism.
>
> Probably my main criticism at this point is that there is no
> commentary explaining how it works.
> You appear to have chosen to run your own reshape thread rather than
> providing a "resync" method and make use of the md_do_sync thread
> which provides speed limiting etc.
> Maybe that it a good decision, but as you haven't explained it, it is
> hard to be sure.
You are correct , I will move to md resync; online reshape is essential=
=2E
I just need to understand the entire md resync processes for that. I
am going to
base raid0 reshape code like raid1's, meaning, have two threads,
raid0_resync and
raid0d for the writes.
Thank you Neil

> Also, it seems to if an IO request arrives while the reshape is
> happening, then it fails with -EBUSY.
> I don't think that is a good thing.
> 1/ no filesystem is going to be expecting EBUSY so it could cause
> =A0 serious problems
> 2/ if you aren't going to support online reshape so that a device can
> =A0 be reshaped while it is in use, then there seems to be little poi=
nt
> =A0 in putting this code in the kernel. =A0Just write a program that =
runs
> =A0 in userspace which reshapes the array while it is not assembled.
>
> Also, I cannot see any evidence that you checkpoint the reshape at
> all. =A0So if your machine crashes during the reshape, everything is
> lost. =A0I do not find this acceptable.
>
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
