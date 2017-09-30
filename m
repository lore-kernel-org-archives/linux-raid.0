From: "John Stoffel" <john@stoffel.org>
Subject: Re: Accidentally resized array to 9
Date: Sat, 30 Sep 2017 19:30:50 -0400
Message-ID: <22992.10538.57015.310576@quad.stoffel.home>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
        <20170929175524.57fea3b5@natsu>
        <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
        <20170930005005.68beae8b@natsu>
        <de7d94b2-7d2c-1419-420d-65b6f531c37f@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de7d94b2-7d2c-1419-420d-65b6f531c37f@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

>>>>> "Phil" == Phil Turmel <philip@turmel.org> writes:

Phil> On 09/29/2017 03:50 PM, Roman Mamedov wrote:
>> On Fri, 29 Sep 2017 10:53:57 -0400
>> Eli Ben-Shoshan <eli@benshoshan.com> wrote:
>> 
>>> I am just hoping that there might be a way that I can get the 
>>> data back.
>> 
>> In theory what you did was cut the array size to only use 9 KB of each device,
>> then reshaped THAT tiny array from 8 to 9 devices, with the rest left
>> completely untouched.
>> 
>> So you could try removing the "new" disk, then try --create --assume-clean
>> with old devices only and --raid-devices=8.
>> 
>> But I'm not sure how you would get the device order right.
>> 
>> Ideally what you can hope for, is you would get the bulk of array data intact,
>> only with the first 9 KB of each device *(8-2), so about the first 54 KB of
>> data on the md array, corrupted and unusable. It is likely the LVM and
>> filesystem tools will not recognize anything due to that, so you will need to
>> use some data recovery software to look for and save the data.
>> 

Phil> I agree with Roman.  Most of your array should be still on the 8-disk
Phil> layout.  But you were mounted and had writing processes immediately
Phil> after the broken grow, so there's probably other corruption due to
Phil> writes on the 9-disk pattern in the 8 disks.

Phil> Roman's suggestion is the best plan, but even after restoring LVM,
Phil> expect breakage all over.  Use overlays.

Maybe the answer is to remove the added disk, setup an overlay on the
eight remaining disks, and then try to do mdadm --create ... on each
of the permutations.  Then you would bring up the LVs on there and see
if you can fsck them and get some data back.

I think the grow isn't going to work, it's really quite hosed at this
point.

If I find some time, I think I'll try to spin up a patch to mdadm to
hopefully stop issues like this from happening, by stopping a --size
to a smaller size with an explicit confirmation being asked, or
overridden by a flag to force the shrink.  Since it's so damn painful.

I don't have alot of hope here for you unfortunately.  I think you're
now in the stage where a --create using the original eight disks is
the way to go.

You *might* be able to find RAID backups at some offset into the disks
to tell you what order each disk is in.  So the steps, roughly, would
be:

1. stop /dev/md127
2. remove the new disk.
3. setup overlays again.

4. mdadm --create /dev/md127 --level 6 -n 8 /dev/sd{cdefghij}

5. vgchange -ay /dev/md127
6. lvs
7. fsck ....
8. if nothing, loop back to step four with a different order of
   devices.


If you have any output from before of /proc/mdstat, that would be
helpful, as would a mapping of device name  (/dev/sd*) to serial
number.

[ There's a neat script called 'lsdrv' which you can grab here
(https://github.com/pturmel/lsdrv) to grab and show all this data.
But it's busted for lvcache devices.  Oops!  Time for more hacking! ]

But I hate to say... I suspect you're toast. But don't listen to me.

John


