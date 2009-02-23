From: "NeilBrown" <neilb@suse.de>
Subject: Re: Reliability of bitmapped resync
Date: Tue, 24 Feb 2009 08:31:45 +1100 (EST)
Message-ID: <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>
References: <20090223194019.GA3488@lazy.lzy>
    <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
    <20090223201905.GA7585@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090223201905.GA7585@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, February 24, 2009 7:19 am, Piergiorgio Sartor wrote:
> Hi,
>
>> What exactly do you mean by "check".
>>
>> If you mean "look in /sys/block/md0/md/mismatch_cnt", then that is
>> exactly what I would expect.  The resync found some differences, just
>> as you would expect it to, and reported them.
>>
>> However if by "check" you mean:
>>   echo check > /sys/block/md0/md/sync_action
>>   mdadm --wait /dev/md0
>>   cat /sys/block/md0/md/mismatch_cnt
>
> yes, that is what I mean.
> I start the check _after_ the resync.
>
> Actually, maybe this is not correct, I keep running
> something like:
>
> watch cat /proc/mdstat /sys/block/md2/md/mismatch_cnt
>
> So I can see real-time, so to speak, the check
> progress and the mismatch count, just to have
> an idea on where, on the RAID, the mismatches
> could be located.
>
> Is this a problem?

No, that isn't a problem.


>
>> then I would not expect any mismatches, and the resync should have
>> fixed them.
>>
>> If it is the later, that is a real concern and I will need to look into
>> it.
>> Please let me know exactly which kernel version and mdadm version you
>> are running.
>
> It is an up-to-date Fedora 10, i.e. kernel-2.6.27.15-170.2.24.fc10
> and mdadm-2.6.7.1-1.fc10.

I might have found something.  If the bitmap chunk size is smaller than
the raid10 chunk size, and the first bitmap chunk in a raid10 chunk is
clean, it might be skipping the remaining bitmap chunks in that
raid10 chunk.

Can you please show me "--examine" and "--examine-bitmap" of one of the
devices in your array please.

Thanks,
NeilBrown


