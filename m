From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Wed, 27 Jan 2010 17:15:05 +0100
Message-ID: <4B606689.8060608@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <4B6000F0.2000405@shiftmail.org> <4B6010F5.6030702@texsoft.it> <4B601A5F.9050301@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B601A5F.9050301@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Also is it possible that you experienced an electricity surge or a 
> physical shock on the computer?
No, the machine is well protected by a good UPS unit.


I had a look to the kernel's sources (2.6.24, I'll check later latest 
kernel)
I'm not a kernel's expert, I didn't need to take a deep look inside it 
before, but:


Into drivers/md/raid5.c :

raid5_end_read_request()
{ ...
else if (atomic_read(&rdev->read_errors) > conf->max_nr_stripes)
    printk(KERN_WARNING "raid5:%s: Too many read errors, failing device 
%s.\n", mdname(conf->mddev), bdn);
... }

It surely keeps track of how many read errors occured! So, the driver 
detects recovered read errors and counts them!
Later in the same source:

int run(mddev_t *mddev)
{ ...
conf->max_nr_stripes = NR_STRIPES;
... }

Looks like it statically sets a limit of 256 recovered read errors 
before setting the device as faulty.

Moreover, from the *Documentation/md.txt* file itself, it states that 
for each md device into /sys/block there is a directory for each 
physical device composing the array, like /sys/block/md0/md/dev-sda1, 
each directory containing many device's parameter, and among them:

...
errors
        An approximate count of read errors that have been detected on
        this device but have not caused the device to be evicted from
        the array (either because they were corrected or because they
        happened while the array was read-only).  When using version-1
        metadata, this value persists across restarts of the array.
...

So the info on how many read errors occured on device is collected and 
available!

I would suggest the following, that *would surely help a lot in 
preventing disasters* like mine:

- it seems that the max number of read errors allowed is set statically 
into raid5.c by "conf->max_nr_stripes = NR_STRIPES;" to 256, eventually 
let it be configurable by an entry into /sys/block/mdXX
- let /proc/mdstat report clearly how many read errors occurred per 
device, if any
- let mdadm be configurable in monitor mode to trigger alerts when the 
number of read errors for a device changes or goes > n
- explain clearly in the how-to and other user's documentation what's 
the behaviour of the raid towards read errors; after a fast survey among 
my colleagues, i have noticed nobody was aware of this, and all of them 
were sure that raid had the same behaviour for both write and read errors!

I examined kernel source 2.6.24 and mdadm 2.6.3, maybe into newer 
versions this already happens; if so, sorry.
My knowledge of linux-raud implementation is not good (otherwise I would 
anwser here, not ask :P ), but maybe I can help.

Thanks

Giovanni

