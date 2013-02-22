From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results - 5x SSD RAID5
Date: Fri, 22 Feb 2013 02:10:48 -0600
Message-ID: <51272808.7070302@hardwarefreak.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au> <CAKHEz2ZyG5xQC78GykbWOfk9EF=r7jcSe_01P=bH7NuJuFBEvA@mail.gmail.com> <5113A2D6.20104@websitemanagers.com.au> <CAKHEz2YgiQiknBXju9a=PR3zV1Hb7ux8yBZWywiTi=BXFm20GA@mail.gmail.com> <51150475.2020803@websitemanagers.com.au> <5120A84E.4020702@websitemanagers.com.au> <51222A81.9080600@hardwarefreak.com> <51250377.509@websitemanagers.com.au> <5125B8E5.5000502@hardwarefreak.com> <5125C154.3090603@websitemanagers.com.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5125C154.3090603@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Dave Cundiff <syshackmin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2/21/2013 12:40 AM, Adam Goryachev wrote:
...
> True, I can allocate a larger LV for testing (I think I have around 500G
> free at the moment, just let me know what size I should allocate/etc...)

Before you change your test LV size, do the following:

1.  Make sure stripe_cache_size is as least 8192.  If not:
    ~$ echo 8192 > /sys/block/md0/md/stripe_cache_size
    To make this permanent, add the line to /etc/rc.local

2.  Run fio using this config file and post the results:

[global]
filename=/dev/vg0/testlv (assuming this is still correct)
zero_buffers
numjobs=16
thread
group_reporting
blocksize=256k
ioengine=libaio
iodepth=16
direct=1
size=8g

[read]
rw=randread
stonewall

[write]
rw=randwrite
stonewall

...
> Device Boot Start End Blocks Id System
> /dev/sdb1 64 931770000 465893001 fd Lnx RAID auto
> Warning: Partition 1 does not end on cylinder boundary.
> 
> I think (from the list) that this should now be correct...

Start sector is 64.  That should do it I think.

...
> Tonight, I will increase each xen physical box from having 1 CPU pinned,
> to having 2 CPU's pinned.

I'm not familiar with Xen "pinning".  Do you mean you had less than 6
cores available to each Windows TS VM?  Given that running TS/Citrix
inside a VM is against every BCP due to context switching overhead, you
should make all 6 cores available to each TS VM all the time, if Xen
allows it.  Otherwise you're perennially wasting core cycles that would
benefit user sessions, which could be making everything faster, more
responsive, for everyone.

> The Domain Controller/file server (windows 2000) is configured for 2
> vCPU, but is only using one since windows itself is not setup for
> multiple CPU's. I'll change the windows driver and in theory this should
> allow dual CPU support.

It probably won't make much, if any, difference for this VM.  But if the
box has 6 cores and only one is actually being used, it certainly can't
hurt.

> Generally speaking, complaints have settled down, and I think most users
> are basically happy. I've still had a few users with "outlook crashing",
> and I've now seen that usually the PST file is corrupt. I'm hopeful that

Their .PST files reside on a share on the DC, correct?  And one is 9GB
in size?  I had something really humorous typed in here, but on second
read it was a bit... unprofessional. ;)  It involved padlocks on doors
and a dozen angry wild roos let loose in the office.

> running the scanpst tool will fix the corruptions and stop the outlook
> crashes. In addition, I've found the user with the biggest complaints
> about performance has a 9GB pst file, so a little pruning will improve
> that I suspect.

One effective way to protect stupid users from themselves is mailbox
quotas.  There are none when the MUA owns its mailbox file.  You could
implement NTFS quotas on the user home directory.  Not sure how Outlook
would, or could, handle a disk quota error.  Probably not something MS
programmers would have considered, as they have that Exchange groupware
product they'd rather sell you.

Sounds like it's time to switch them to a local IMAP server such as
Dovecot.  Simple to install in a Debian VM.  Probably not so simple to
get the users to migrate their mail to it.

> So, I think between the above couple of things, and all the other work
> already done, the customer is relatively comfortable (I won't say happy,
> but maybe if we can survive a few weeks without any disaster...).

I hear ya on that.

> Personally, I'd like to improve the RAID performance, just because it
> should, but at least I can relax a little, and dedicate some time to
> other jobs, etc...

I'm not convinced at this point you don't already have it.  You're
basing that assumption on a single disk tester program, and you're not
even running the correct set of tests.  Those above may prove more telling.

> So, summary:
> 1) Disable HT
> 2) Increase test LV to 100G
> 3) Re-run fio test
> 4) Re-collect CPU stats

  5) Get all cores to TS VMs

> Sound good?

Yep.

-- 
Stan

