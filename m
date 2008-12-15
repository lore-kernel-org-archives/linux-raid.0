From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: weird issues with raid1
Date: Mon, 15 Dec 2008 07:42:58 -0600
Message-ID: <cccedfc60812150542y5607d168q94c09d8dc3438226@mail.gmail.com>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com>
	 <18757.62097.166706.244330@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18757.62097.166706.244330@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 15, 2008 at 12:00 AM, Neil Brown <neilb@suse.de> wrote:
> On Friday December 5, jnelson-linux-raid@jamponi.net wrote:
>> I set up a raid1 between some devices, and have been futzing with it.
>> I've been encountering all kinds of weird problems, including one
>> which required me to reboot my machine.
>>
>> This is long, sorry.
>>
>> First, this is how I built the raid:
>>
>> mdadm --create /dev/md10 --level=1 --raid-devices=2 --bitmap=internal
>> /dev/sdd1 --write-mostly --write-behind missing
>
> 'write-behind' is a setting on the bitmap and applies to all
> write-mostly devices, so it can be specified anywhere.
> 'write-mostly' is a setting that applies to a particular device, not
> to a position in the array.  So setting 'write-mostly' on a 'missing'
> device has no useful effect.  When you add a new device to the array
> you will need to set 'write-mostly' on that if you want that feature.

Aha! Good to know.

>   mdadm /dev/md10 --add --write-mostly /dev/nbd0

..

>> Then I failed and removed /dev/sdd1, and added /dev/sda:
>>
>> mdadm /dev/md10 --fail /dev/sdd1 --remove /dev/sdd1
>> mdadm /dev/md10 --add /dev/sda
>>
>> I let it rebuild.
>>
>> Then I failed, and removed it:
>>
>> The --fail worked, but the --remove did not.
>>
>> mdadm /dev/md10 --fail /dev/sda --remove /dev/sda
>> mdadm: set /dev/sda faulty in /dev/md10
>> mdadm: hot remove failed for /dev/sda: Device or resource busy
>
> That is expected.  Marking a device a 'failed' does not immediately
> disconnect it from the array.  You have to wait for any in-flight IO
> requests to complete.

Aha! Got it.

>> OK. Better, but weird.
>> Since I'm using bitmaps, I would expect --re-add to allow the rebuild
>> to pick up where it left off. It was 78% done.
>
> Nope.
> With v0.90 metadata, a spare device is not marked a being part of the
> array until it is fully recovered.  So if you interrupt a recovery
> there is no record how far it got.
> With v1.0 metadata we do record how far the recovery has progressed
> and it can restart.  However I don't think that helps if you fail a
> device - only if you stop the array and later restart it.
>
> The bitmap is really about 'resync', not 'recovery'.

OK, so task 1: switch to 1.0 (1.1, 1.2) metadata. That's going to
happen as soon as my raid10,f2 'check' is complete.

However, it raises a question: bitmaps are about 'resync' not
'recovery'?  How do they differ?

>> Question 1:
>> I'm using a bitmap. Why does the rebuild start completely over?
>
> Because the bitmap isn't used to guide a rebuild, only a resync.
>
> The effect of --re-add is to make md do a resync rather than a rebuild
> if the device was previously a fully active member of the array.

Aha!  This explains a question I raised in another email. What
happened there is a previously fully active member of the raid got
added, somehow, as a spare, via --incremental. That's when the entire
raid thought it needed to be rebuilt. How did that (the device being
treated as a spare instead of as a previously fully active member)
happen?

>> 4% into the rebuild, this is what --examine-bitmap looks like for both
>> components:
>>
>>         Filename : /dev/sda
>>            Magic : 6d746962
>>          Version : 4
>>             UUID : 542a0986:dd465da6:b224af07:ed28e4e5
>>           Events : 500
>>   Events Cleared : 496
>>            State : OK
>>        Chunksize : 256 KB
>>           Daemon : 5s flush period
>>       Write Mode : Allow write behind, max 256
>>        Sync Size : 78123968 (74.50 GiB 80.00 GB)
>>           Bitmap : 305172 bits (chunks), 305172 dirty (100.0%)
>>
>> turnip:~ # mdadm --examine-bitmap /dev/nbd0
>>         Filename : /dev/nbd0
>>            Magic : 6d746962
>>          Version : 4
>>             UUID : 542a0986:dd465da6:b224af07:ed28e4e5
>>           Events : 524
>>   Events Cleared : 496
>>            State : OK
>>        Chunksize : 256 KB
>>           Daemon : 5s flush period
>>       Write Mode : Allow write behind, max 256
>>        Sync Size : 78123968 (74.50 GiB 80.00 GB)
>>           Bitmap : 305172 bits (chunks), 0 dirty (0.0%)
>>
>>
>> No matter how long I wait, until it is rebuilt, the bitmap on /dev/sda
>> is always 100% dirty.
>> If I --fail, --remove (twice) /dev/sda, and I re-add /dev/sdd1, it
>> clearly uses the bitmap and re-syncs in under 1 second.
>
> Yes, there is a bug here.
> When an array recovers on to a hot space it doesn't copy the bitmap
> across.  That will only happen lazily as bits are updated.
> I'm surprised I hadn't noticed that before, so they might be more to
> this than I'm seeing at the moment.   But I definitely cannot find
> code to copy the bitmap across.  I'll have to have a think about
> that.

ok.

>> Question 2: mdadm --detail and cat /proc/mdstat do not agree:
>>
>> NOTE: mdadm --detail says the rebuild status is 0% complete, but cat
>> /proc/mdstat shows it as 7%.
>> A bit later, I check again and they both agree - 14%.
>> Below, from when the rebuild was 7% according to /proc/mdstat
>
> I cannot explain this except to wonder if 7% of the recovery
> completed between running "mdadm -D" and "cat /proc/mdstat".
>
> The number report by "mdadm -D" is obtained by reading /proc/mdstat
> and applying "atoi()" to the string that ends with a '%'.

OK. As I see it, there are three issues here:

1. somehow a previously fully-active member got re-added (via
--incremental) as a spare instead simply re-added, forcing a full
rebuild.

2. new raid member bitmap weirdness (the bitmap doesn't get copied
over on new members, causing all sorts of weirdness).

3. The unexplained difference between mdadm --detail and cat /proc/mdstat

I have a few more questions / observations I'd like to make but I'll
do those in another email.

Thanks for your response(s)!

-- 
Jon
