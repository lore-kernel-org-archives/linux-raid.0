From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Reshape/Grow to fewer but bigger devices
Date: Wed, 31 Jul 2013 03:18:03 -0500
Message-ID: <51F8C83B.5070701@hardwarefreak.com>
References: <CAHhAHviuST+LXb36-XOz+UtZiFv0j8AX+iZ0_gS2MCWZaYhiQg@mail.gmail.com> <CAHhAHvhek+ObrM3drgyfs3EH6itoyB2WjxkBK2TcmORw0N_STQ@mail.gmail.com> <20130731132858.10c67a46@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130731132858.10c67a46@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Christian Nilsson <nikize@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/30/2013 10:28 PM, NeilBrown wrote:
> On Wed, 31 Jul 2013 01:33:46 +0200 Christian Nilsson <nikize@gmail.com> wrote:
...
>> but just to explain:
>> I have a 9 devices in a RAID5
>> 6 of these are now 2TB disks (I really love hot replace!)
>> while the other 3 are still 1TB disks
>>
>> I would now like to grow the array to 6x2TB instead of the present 9x1TB.
>>
>> Is this possible and I just can't find how, or have there just been to
>> many other great features instead?
>> (I have started a ext4 offline shrink.. but it is a real pain.)
> 
> Sorry, but this function hasn't been implemented yet.


Christian, there is an old storage industry axiom that goes something
like "one can only afford as much storage as one can afford to back up".

This says that you need sufficient storage media to backup the files
residing in the filesystem on your primary storage array.  It seems
clear that you currently have no such backup media nor strategy.  The
only suitable consumer media with sufficient capacity would be more hard
drives.

I'd suggest acquiring a pair of 4TB drives, or 3x3TB depending on price
break, to use from this point forward strictly as backup media.  Create
an md linear array of the new drives, format it with XFS.  Look at the
directory structure of your existing array and based on that fire off
multiple 'cp -a' commands in parallel to copy the dirs and files over.
This method will get all backup disks in play due to AG parallelism in
XFS, increasing throughput, and decreasing total backup time.

Once you're backed up, blow away the original array and create a new
one, but I suggest using your 6x2TB disks in RAID6 instead of RAID5.
IMO, and that of many others here, RAID5 with many muti-TB disks is
simply too prone to double disk failure during rebuilds/reshapes, silent
data corruption due to the RAID5 write hole, etc, especially with
consumer quality drives.  With many hi-cap consumer drives, RAID5 is a
time bomb.

So in the end you'll have 1TB less raw capacity, 8TB vs 9TB, but you'll
be protected by double parity RAID6 and you'll have sufficient backup
device capacity to safeguard your primary array, even if it's completely
full.  Once everything is migrated you'll want to implement a scheduled
backup strategy using rsync or something similar, so you're
automatically backing up new files and those that have changed, on a
daily schedule.  Nobody needs a backup until they need it.  Don't find
yourself needing one and not having it.

-- 
Stan

