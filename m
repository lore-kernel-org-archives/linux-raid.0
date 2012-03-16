From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Fri, 16 Mar 2012 07:25:05 -0500
Message-ID: <4F633121.10800@hardwarefreak.com>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com> <4F61803A.60009@hardwarefreak.com> <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/15/2012 7:06 AM, Jessie Evangelista wrote:
> On Thu, Mar 15, 2012 at 1:38 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:

>> Why 256KB for chunk size?
>>
> For reference, the machine has 16GB memory
> 
> I've run some benchmarks with dd trying the different chunks and 256k
> seems like the sweetspot.
> dd if=/dev/zero of=/dev/md0 bs=64k count=655360 oflag=direct

Using dd in this manner is precisely analogous to taking your daily
driver Toyota to the local drag strip, making a few runs, and observing
your car can accelerate from 0-92 mph in 1320 ft.  This has no
correlation to daily driving on public roads.

> I'll probably forgo setting the journal log file size. It seemed like
> a safe optimization from what I've read.

See:
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> I just wanted to be explicit about it so that I know what is set just
> in case the defaults change

See:
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

Even if the XFS mount defaults change you won't notice a difference, not
on this server, except for possibly delaylog if you do a lot of 'rm -rf'
operations on directories containing tens of thousands of files.
Delaylog is the only mount default change in many years.  It occurred in
2.6.39, which is why I recommended this rev as the minimum you should
choose.

>> In fact, it appears you don't need to specify anything in mkfs.xfs or
>> fstab, but just use the defaults.  Fancy that.  And the one thing that
>> might actually increase your performance a little bit you didn't
>> specify--sunit/swidth.  However, since you're using mdraid, mkfs.xfs
>> will calculate these for you (which is nice as mdraid10 with odd disk
>> count can be a tricky calculation).  Again, defaults work for a reason.
>>
> The reason I did not set sunit/swidth is because I read somewhere that
> mkfs.xfs will calculate based on mdraid.

I guess my stating of the same got lost in the rest of that paragraph. ;)

> The server is for a non-profit org that I am helping out.
> I think a APC Smart-UPS SC 420VA 230V may fit their shoe string budget.

Given the rough server specs you presented, a 420 (260 watts) should be
fine, assuming you're not running seti@home, folding@home, etc, which
can double average system power draw.  A 420 won't yield much battery
run time but will give more than enough time for a clean shutdown.  Are
you sure you want a 230v model?  If so I'd guess you're outside the
States.  Also:  http://www.apcupsd.com/  APC control daemon with auto
shutdown.

> nightly backups will be stored on an external USB disk
> is xfs going to be prone to more data loss in case the non-redundant
> power supply goes out?

There are bigger issues here WRT XFS and USB connected disks IIRC from
some list posts.  USB is prone to random device/bus disconnections due
to power management in various USB controllers.  XFS design assumes
storage devices are persistently connected, and it does frequent
background reads/writes to the device.  If the USB drive is offline long
enough, lots of errors are logged, and XFS can't access it, it may/will
shutdown the filesystem as a safety precaution.  If you want to use XFS
on that external USB drive, you need to do some research first--I don't
have solid answers for you here.  Or simply use EXT3/4.  XFS isn't going
to yield any advantage with single threaded backup anyway, so maybe just
going with EXT is the smart move.

>> I'll appreciate your response stating "Yes, I have a UPS and
>> tested/working shutdown scripts" or "I'll be implementing a UPS very
>> soon." :)
> 
> I don't have shutdown scripts yet but will look into it.

Again:  http://www.apcupsd.com/  There may be others available.

> Meatware would have to do for now as the server will probably be ON
> only when there's people at the office. 

I just hope do proper shutdowns when they power it off. ;)

> And yes I will be asking them
> to not go into production without a UPS

If it's a hard sell, simply explain that every laptop has a built in
UPS, and that the server and its data are obviously as important, if not
more, than any laptop.

> Thanks for you input Stan.

You're welcome.

> I just updated the kernel to 3.0.0-16.
> Did they take out barrier support in mdraid? or was the implementation
> replaced with FUA?

Write barriers, in one form or another, are there.  These will never be
removed or broken--too critical.  The implementation may have changed.
Neil can answer this much better than me.

> Is there a definitive test to determine if the off the shelf consumer
> sata drives honor barrier or cache flush requests?

Just connect the drive and boot up.  You'll see this in dmesg:

sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA

And:
$ hdparm -I /dev/sda
...
Commands/features:
        Enabled Supported:
                ...
           *    Write cache
                ...
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
                ...
These are good indicators that the drive supports barrier operations.

> I think I'd like to go with device cache turned ON and barrier enabled.

You just stated the the Linux defaults.  Do note that XFS write barriers
will ensure journal and thus filesystem integrity in a crash/power fail
event.  They do NOT guarantee file data integrity as file data isn't
journaled.  No filesystem (Linux anyway) journals data, only metadata.
To prevent file data loss due to a crash/power fail, you must disable
the drive write caches completely and/or use a BBWC RAID card.

As you know performance is horrible with caches disabled.  With so few
users and so little data writes, you're safe running with barriers and
write cache enabled.  This is how most people on this list with plain
HBAs run their systems.

> Am still torn between ext4 and xfs i.e. which will be safer in this
> particular setup.

Neither is "safer" than the other.  That's up to your hardware and power
configuration.  Pick the one you are most comfortable working with and
have the most experience supporting.  For this non-prof SOHO workload,
XFS' advanced features will yield little, if any, performance
advantage--you have too few users, disks, and too little IO.

If this box had, say, 24 cores, 128GB RAM, and 192 15k SAS drives across
4 dual port SAS RAID HBAs, 8x24 drive hardware RAID10s in an mdraid
linear array, with a user IO load demanding such a system--multiple GB/s
of concurrent IO, then the only choice is XFS.  EXT4 simply can't scale
close to anything like this.

All things considered, for your system, EXT4 is probably the best choice.

-- 
Stan
