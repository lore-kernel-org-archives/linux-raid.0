From: "NeilBrown" <neilb@suse.de>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Wed, 4 Nov 2009 14:45:52 +1100
Message-ID: <b8766f41cb8589519feec9f853217492.squirrel@neil.brown.name>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
    <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
    <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>
    <f3177b9e0911031129g2e0026f6s65275b8f684438f4@mail.gmail.com>
    <4877c76c0911031611h3572851avaed9870795db3d92@mail.gmail.com>
    <f3177b9e0911031621p29c390e4xc5017001a38046ff@mail.gmail.com>
    <4877c76c0911031629n580dc25ay7e47990908b056e7@mail.gmail.com>
    <f3177b9e0911031637y6a025d2er5b23408cead22803@mail.gmail.com>
    <4877c76c0911031641k313ad6efj8678eea92b66be69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911031641k313ad6efj8678eea92b66be69@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Chris Worley <worleys@gmail.com>, Sujit K M <sjt.kar@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, November 4, 2009 11:41 am, Michael Evans wrote:
> On Tue, Nov 3, 2009 at 4:37 PM, Chris Worley <worleys@gmail.com> wrot=
e:
>> On Tue, Nov 3, 2009 at 5:29 PM, Michael Evans <mjevans1983@gmail.com=
>
>> wrote:
>>>>
>>>> So, you're saying that the MD layer is doing it's own buffering? =A0=
Are
>>>> you sure? =A0With the system cache disabled and the drive (and blo=
ck
>>>> device driver) cache disabled, there should be no reason to requir=
e
>>>> synchronous I/O, unless, as you suggest, the MD layer is broken.

MD only does buffering for RAID4/5/6, and then normally only for writes=
=2E
It has to buffer writes so that it can create the XOR reliably.

>>>>
>>>> You're saying that both O_DIRECT and O_SYNC must be used to disabl=
e
>>>> cache effects. Why then are there two separate flags and not just =
one?
>>>> =A0Synchronous is a very different behavior that is not necessary =
for
>>>> this test and put additional requirements that are not needed for =
this

Without O_SYNC, the filesystem metadata which records where the blocks
in the file are may be not be updated synchronously.  This is probably
what you want when testing device throughput.
So just using O_DIRECT is correct.


>>>> test.
>>>>
>>>> Chris
>>>>
>>>
>>> Reading the manual page it seems O_DIRECT explicitly minimizes any
>>> attempts at extra copying; not explicitly disabling buffers, merely
>>> not adding more. =A0In another mail thread this tweak-able was
>>> discussed:
>>>
>>> echo 0 > /sys/block/md*/md/stripe_cache_size
>>>
>>> Which would should (I think) disable any cache involved with the md
>>> layer.

And given that the cache - where available - is essential, this would
effectively stop your md array.... except that numbers less than 16 are
rejected.


>>
>> Stripe_cache_size doesn't seem to exist in the /sys/block/md*/md/
>> directory on the RHEL5.3 2.6.18-92 kernel I'm using.
>>
>> # ls /sys/block/md*/md/s*
>> /sys/block/md0/md/safe_mode_delay =A0/sys/block/md0/md/suspend_hi
>> /sys/block/md0/md/suspend_lo =A0/sys/block/md0/md/sync_action
>> /sys/block/md0/md/sync_completed =A0/sys/block/md0/md/sync_speed
>> /sys/block/md0/md/sync_speed_max =A0/sys/block/md0/md/sync_speed_min

RAID1 does not have a stripe cache, hence no 'stripe_cache_size'.

As to why RAID1 appears fast than the plain drive, I cannot imagine.
I would need specific details of exactly the tests that were run,
exactly the results obtained, and exactly the version of the
various software used.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
