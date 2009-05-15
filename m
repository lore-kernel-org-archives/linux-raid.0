From: "NeilBrown" <neilb@suse.de>
Subject: RE: resync duration ?
Date: Fri, 15 May 2009 14:44:05 +1000 (EST)
Message-ID: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>
References: <20090515040451334.NCNJ13751@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090515040451334.NCNJ13751@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 15, 2009 2:04 pm, Leslie Rhorer wrote:
>> > I'm a but confused about the duration of a raid5 resync:
>> >
>> > - occasionally, my server with 4*750 gb sata raid5 crashed (because of
>> > problems with the power supply); after rebooting it took about 10 to
>> 12
>> > hours to resync the raid5 (guess it just re-created some parity
>> > information or however it works internally, but didn't have to copy
>> > any data)
>>
>> A resync reads all the data and checks the parity.  If it find bad
>> parity (which is likely to be very rare) then it corrects it.
>> So resync should run at the full speed of the hardware, just reading.
>
> It will?  Maybe I am just mis-remembering, but I thought I saw the same
> note
> in the log when the resync occurred (ckarray) as when a recovery was in
> progress:
>
> May 14 22:40:42 Backup kernel: [ 8083.747787] md: recovery of RAID array
> md0
> May 14 22:40:42 Backup kernel: [ 8083.747789] md: minimum _guaranteed_
> speed: 1000 KB/sec/disk.
> May 14 22:40:42 Backup kernel: [ 8083.747791] md: using maximum available
> idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> May 14 22:40:42 Backup kernel: [ 8083.747797] md: using 128k window, over
> a
> total of 1465138432 blocks.
>
> Am I mis-remembering, or am I missing something here?

It isn't clear to me exactly what you are asking...

It says it won't use more than 200MB/sec, which is true. But that is
per-device, and few devices can deliver that yet.

It says "using maximum available", so it if you want the bandwidth
for something else, it will back off.

It prints the same message for resync as for recovery.



>
> Oh, while I am thinking of it, ckarray runs every month on the first of
> the
> month, but how can one trigger it manually?

  echo check > /sys/block/mdX/md/sync_action.

or "echo repair" to get it to fix anything it finds.

NeilBrown

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

