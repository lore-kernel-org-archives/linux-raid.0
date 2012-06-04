From: Pierre Beck <mail@pierre-beck.de>
Subject: Re: Data Offset
Date: Mon, 04 Jun 2012 20:26:05 +0200
Message-ID: <4FCCFDBB.201@pierre-beck.de>
References: <CAFhY2CjOECFy4bWDL6zs9rtSkVGPR9Wv=1UX9vKgmdjwMsmBYg@mail.gmail.com> <20120602095237.3822e2c2@notabene.brown> <CAFhY2Cjwep5mZkYCfRn4UYmQpSyHU13dSCB8HF8F9wG8Rzx9Aw@mail.gmail.com> <20120604133526.6da3bf10@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604133526.6da3bf10@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: freeone3000 <freeone3000@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll try and clear up some confusion (I was in IRC with freeone3000).

/dev/sdf is an empty drive, a replacement for a failed drive. The Array 
attempted to assemble, but failed and reported one drive as spare. This 
is the moment we saved the --examines.

In expectation of a lost write due to drive write-cache, we executed 
--assemble --force, which kicked another drive.

@James: remove /dev/sdf for now and replace /dev/sde3, which indeed has 
a very outdated update time, with the non-present drive. Post an 
--examine of that drive. It should report update time Jun 1st.

We tried to re-create the array with --assume-clean. But mdadm chose a 
different data offset for the drives. A re-create with proper data 
offset will be necessary.

Greetings,

Pierre Beck


Am 04.06.2012 05:35, schrieb NeilBrown:
> On Fri, 1 Jun 2012 19:48:41 -0500 freeone3000<freeone3000@gmail.com>  wrote:
>
>> Sorry.
>>
>> /dev/sde fell out of the array, so I replaced the physical drive with
>> what is now /dev/sdf. udev may have relabelled the drive - smartctl
>> states that the drive that is now /dev/sde works fine.
>> /dev/sdf is a new drive. /dev/sdf has a single, whole-disk partition
>> with type marked as raid. It is physically larger than the others.
>>
>> /dev/sdf1 doesn't have a mdadm superblock. /dev/sdf seems to, so I
>> gave output of that device instead of /dev/sdf1, despite the
>> partition. Whole-drive RAID is fine, if it gets it working.
>>
>> What I'm attempting to do is rebuild the RAID from the data from the
>> other four drives, and bring the RAID back up without losing any of
>> the data. /dev/sdb3, /dev/sdc3, /dev/sdd3, and what is now /dev/sde3
>> should be used to rebuild the array, with /dev/sdf as a new drive. If
>> I can get the array back up with all my data and all five drives in
>> use, I'll be very happy.
> You appear to have 3 devices that are happy:
>    sdc3 is device 0   data-offset 2048
>    sdb3 is device 1   data-offset 2048
>    sdd3 is device 3   data-offset 1024
>
> nothing claims to be device 2 or 4.
>
> sde3 looks like it was last in the array on 23rd May, a little over
> a week before your report.  Could that have been when "sde fell out of the
> array" ??
> Is it possible that you replaced the wrong device?
> Or is it possible the the array was degraded when sde "fell out" resulting
> in data loss?
>
> I need more precise history to understand what happened, as I cannot suggest
> a fixed until I have that understanding.
>
> When did the array fail?
> How certain are you that you replaced the correct device?
> Can you examine the drive that you removed and see what it says?
> Are you certain that the array wasn't already degraded?
>
> NeilBrown
>

