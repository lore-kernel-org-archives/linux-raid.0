From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: O_DIRECT to md raid 6 is slow
Date: Wed, 15 Aug 2012 17:00:33 -0500
Message-ID: <502C1C01.1040509@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <502B8D1F.7030706@anonymous.org.uk> <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/15/2012 12:57 PM, Andy Lutomirski wrote:
> On Wed, Aug 15, 2012 at 4:50 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> On 15/08/2012 01:49, Andy Lutomirski wrote:
>>>
>>> If I do:
>>> # dd if=/dev/zero of=/dev/md0p1 bs=8M
>>
>> [...]
>>
>>> It looks like md isn't recognizing that I'm writing whole stripes when
>>> I'm in O_DIRECT mode.
>>
>>
>> I see your md device is partitioned. Is the partition itself stripe-aligned?
> 
> Crud.
> 
> md0 : active raid6 sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>       11720536064 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [6/6] [UUUUUU]
> 
> IIUC this means that I/O should be aligned on 2MB boundaries (512k
> chunk * 4 non-parity disks).  gdisk put my partition on a 2048 sector
> (i.e. 1MB) boundary.

It's time to blow away the array and start over.  You're already
misaligned, and a 512KB chunk is insanely unsuitable for parity RAID,
but for a handful of niche all streaming workloads with little/no
rewrite, such as video surveillance or DVR workloads.

Yes, 512KB is the md 1.2 default.  And yes, it is insane.  Here's why:
Deleting a single file changes only a few bytes of directory metadata.
With your 6 drive md/RAID6 with 512KB chunk, you must read 3MB of data,
modify the directory block in question, calculate parity, then write out
3MB of data to rust.  So you consume 6MB of bandwidth to write less than
a dozen bytes.  With a 12 drive RAID6 that's 12MB of bandwidth to modify
a few bytes of metadata.  Yes, insane.

Parity RAID sucks in general because of RMW, but it is orders of
magnitude worse when one chooses to use an insane chunk size to boot,
and especially so with a large drive count.

It seems people tend to use large chunk sizes because array
initialization is a bit faster, and running block x-fer "tests" with dd
buffered sequential reads/writes makes their Levi's expand.  Then they
are confused when their actual workloads are horribly slow.

Recreate your array, partition aligned, and manually specify a sane
chunk size of something like 32KB.  You'll be much happier with real
workloads.

-- 
Stan
