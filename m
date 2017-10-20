From: Liwei <xieliwei@gmail.com>
Subject: Re: RAID6: Reducing to Grow
Date: Fri, 20 Oct 2017 13:04:38 +0800
Message-ID: <CAPE0SYxOnzhEwaxBipUsMVrgtfNPyFRRMOa-Zg4fA+O0Zmk=CQ@mail.gmail.com>
References: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
 <ba94e811-1ae4-a8a3-5907-bde289b44754@turmel.org> <9ef8359d-7da9-de5a-d939-46a3c51cc68d@gmail.com>
 <0f2b759f-3f4d-127a-242a-74c3f8abdea4@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0f2b759f-3f4d-127a-242a-74c3f8abdea4@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,

On 19 October 2017 at 02:02, Phil Turmel <philip@turmel.org> wrote:
> On 10/18/2017 01:20 AM, Liwei wrote:
>> Hi Phil,
>
>
>> Whoops, we do run LVM on top, but currently it is one gigantic LV. (We
>> converted to btrfs and started using subvolumes instead) My guess is
>> you're thinking of creating another array with the unused space, and
>> then migrating LVs over?
>
> Yes.  With temporary ~4T partitions.
>
>> The lsdrv output follows, with a lot of irrelevant/empty nodes removed.
>> Also, I realised I misread the storage size of two of the 2TB drives, so
>> we're actually at 9x 2TB and 4x 6TB.
>
> Very helpful.
>
>> _However_, I do have one 6TB "hot spare" plugged in, and 3 proper 6TB
>> SAS drives arriving next week, so there may still be a way to do this,
>> perhaps?
>
> Makes it easy, actually.
>
> So, here's what I recommend:
>
> 1) Set long timeouts on your desktop drives, the WD*EARS and WD*FASS:
>
> for x in a b j l ; do echo 180 > /sys/block/sd$x/device/timeout ; done
>
> 2) Scrub your array (and wait for it to finish):
>
> echo check >/sys/block/md126/md/sync_action
>
> 3) After installing the new drives, fail one of your 6T drives out of
> the array, then use it, the hot spare, the new drives, and one 'missing'
> to set up a new degraded 6-drive raid6.  Consider using a smaller chunk
> size unless you are storing very large media files.  (I use 16k or 32k
> for my parity arrays.)
>
> 4) Add the new array as a physical volume to your existing volume group.
>
> 5) Use lvconvert to change LV Wonderland to a mirror.  You could just use
> pvmove if you don't mind the reduced redundancy.  Let it get fully
> mirrored or moved.  Skip to step #8 if you used pvmove.
>
> 6) Fail another 6T drive from the existing array and add it to the new
> array.  Let it rebuild.
>
> 7) Use lvconvert to change LV Wonderland back into an unmirrored LV on
> the new array.  Be careful to specify the new array!
>
> 8) Remove the old array from your volume group with vgreduce.  Shut down
> the old array and use mdadm --zero-superblock on its prior members.
> Get rid of the desktop drives.
>
> 9) Add all the newly available 6T drives to the new array.  Let it
> rebuild if necessary.
>
> 10) Grow the new array to occupy all of the space on all of the devices,
> or maybe leave one hot spare.  (I wouldn't, but it depends on your
> application and your supply chain.)
>
> 11) Enjoy all that space!
>
> Note that all of the above can be executed while using your mounted LV.
>
> Phil

Great! I'm done with the scrub, now waiting for the new drives to arrive.

I anticipate there'll be quite a bit of downtime involved though. Our
chassis only has 16 cages, so we probably have to temporarily move one
or two of the 2TB drives onto the internal SATA connectors and hang
them around. Power might be an issue too, but we'll figure it out,
hopefully without frying any drives. ;)

My guess is I should probably scrub again after relocating the drives,
just to be sure they work under load.

Regarding the chunk size, my predecessor initially chose 512k based on
some reading about performance boost with raw video files and 4k/AF
drives, not sure whether it holds water. Something along the lines of:
we're dealing with multi gigabyte files anyway, what's wastage of half
a meg here and there? Supposedly RW performance increases with chunk
size - provided they're properly aligned, but it is a diminishing
return.

We're using this NAS to ingest the raw video files from our HD and 4K
cameras so they can be accessed remotely for editing, does 512k chunk
size make sense or should I go down to 16/32k?

Thank you for the assistance so far!

Liwei
