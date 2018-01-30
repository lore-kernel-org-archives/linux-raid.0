From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Tue, 30 Jan 2018 10:40:49 +0100
Message-ID: <mqd607jn0pq.fsf@linux-x5ow.site>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
        <5A6F4CA6.5060802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5A6F4CA6.5060802@youngman.org.uk> (Wols Lists's message of "Mon,
        29 Jan 2018 16:32:38 +0000")
Sender: linux-block-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: lsf-pc@lists.linux-foundation.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Wols Lists <antlists@youngman.org.uk> writes:

> On 29/01/18 15:23, Johannes Thumshirn wrote:
>> Hi linux-raid, lsf-pc
>> 
>> (If you've received this mail multiple times, I'm sorry, I'm having
>> trouble with the mail setup).
>
> My immediate reactions as a lay person (I edit the raid wiki) ...
>> 
>> With the rise of bigger and bigger disks, array rebuilding times start
>> skyrocketing.
>
> And? Yes, your data is at risk during a rebuild, but md-raid throttles
> the i/o, so it doesn't hammer the system.
>> 
>> In a paper form '92 Holland and Gibson [1] suggest a mapping algorithm
>> similar to RAID5 but instead of utilizing all disks in an array for
>> every I/O operation, but implement a per-I/O mapping function to only
>> use a subset of the available disks.
>> 
>> This has at least two advantages:
>> 1) If one disk has to be replaced, it's not needed to read the data from
>>    all disks to recover the one failed disk so non-affected disks can be
>>    used for real user I/O and not just recovery and
>
> Again, that's throttling, so that's not a problem ...

And throttling in a production environment is not exactly
desired. Imagine a 500 disk array (and yes this is something we've seen
with MD) and you have to replace disks. While the array is rebuilt you
have to throttle all I/O because with raid-{1,5,6,10} all data is
striped across all disks.

With a parity declustered RAID (or DDP like Dell, NetApp or Huawei call
it) you don't have to as the I/O is replicated in parity groups across a
subset of disks. All I/O targeting disks which aren't needed to recover
the data from the failed disks aren't affected by the throttling at all.

>> 2) an efficient mapping function can improve parallel I/O submission, as
>>    two different I/Os are not necessarily going to the same disks in the
>>    array. 
>> 
>> For the mapping function used a hashing algorithm like Ceph's CRUSH [2]
>> would be ideal, as it provides a pseudo random but deterministic mapping
>> for the I/O onto the drives.
>> 
>> This whole declustering of cause only makes sense for more than (at
>> least) 4 drives but we do have customers with several orders of
>> magnitude more drivers in an MD array.
>
> If you have four drives or more - especially if they are multi-terabyte
> drives - you should NOT be using raid-5 ...

raid-6 won't help you much in above scenario.

>> 
>> At LSF I'd like to discuss if:
>> 1) The wider MD audience is interested in de-clusterd RAID with MD
>
> I haven't read the papers, so no comment, sorry.
>
>> 2) de-clustered RAID should be implemented as a sublevel of RAID5 or
>>    as a new personality
>
> Neither! If you're going to do it, it should be raid-6.
>
>> 3) CRUSH is a suitible algorith for this (there's evidence in [3] that
>>    the NetApp E-Series Arrays do use CRUSH for parity declustering)
>> 
>> [1] http://www.pdl.cmu.edu/PDL-FTP/Declustering/ASPLOS.pdf 
>> [2] https://ceph.com/wp-content/uploads/2016/08/weil-crush-sc06.pdf
>> [3]
>> https://www.snia.org/sites/default/files/files2/files2/SDC2013/presentations/DistributedStorage/Jibbe-Gwaltney_Method-to_Establish_High_Availability.pdf
>> 
> Okay - I've now skimmed the crush paper [2]. Looks well interesting.
> BUT. It feels more like btrfs than it does like raid.
>
> Btrfs manages disks, and does raid, it tries to be the "everything
> between the hard drive and the file". This crush thingy reads to me like
> it wants to be the same. There's nothing wrong with that, but md is a
> unix-y "do one thing (raid) and do it well".

Well CRUSH is (one of) the algorithms behind Ceph. It takes the
decisions where to place a block. It is just a hash (well technically a
weighted decision-tree) function that takes a block of I/O and a some
configuration parameters and "calculates" the placement.

> My knee-jerk reaction is if you want to go for it, it sounds like a good
> idea. It just doesn't really feel a good fit for md.

Thanks for the input.

       Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
