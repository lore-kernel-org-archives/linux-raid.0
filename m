From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 13:05:25 +0100
Message-ID: <49EDB685.7000004@anonymous.org.uk>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>	<49ED096E.1000002@anonymous.org.uk>	<49ED16F7.3040906@anonymous.org.uk>	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>	<49ED2BC3.7050109@anonymous.org.uk> <18925.24241.19288.797776@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18925.24241.19288.797776@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/04/2009 06:50, Neil Brown wrote:
> On Tuesday April 21, john.robinson@anonymous.org.uk wrote:
>> Eeek! Trying to `mdadm --grow /dev/md1 --bitmap=none` from my large 
>> chunk size caused a reboot! There's nothing in the log, and I didn't see 
>> the console. I still have my 32M chunksize but I don't want to try that 
>> again in a hurry :-)
> 
> That's a worry... I cannot easily reproduce it.  If it happens again
> and you get any more detail, I'm sure you'll let me know.

Sure will. For the moment I have something that looks slightly 
inconsistent: mdadm --detail shows no bitmap after the crash:
# mdadm --detail /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Mon Jul 28 15:49:09 2008
      Raid Level : raid5
      Array Size : 1953310720 (1862.82 GiB 2000.19 GB)
   Used Dev Size : 976655360 (931.41 GiB 1000.10 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Tue Apr 21 12:37:15 2009
           State : clean
  Active Devices : 3
Working Devices : 3
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 256K

            UUID : d8c57a89:166ee722:23adec48:1574b5fc
          Events : 0.6152

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2

and indeed another attempt to remove the bitmap fails gently:
# mdadm --grow /dev/md1 --bitmap none
mdadm: no bitmap found on /dev/md1

However examining any of the devices making up the RAID appears to 
suggest there is a bitmap:
# mdadm --examine-bitmap /dev/sda2
         Filename : /dev/sda2
            Magic : 6d746962
          Version : 4
             UUID : d8c57a89:166ee722:23adec48:1574b5fc
           Events : 6148
   Events Cleared : 6148
            State : OK
        Chunksize : 32 MB
           Daemon : 5s flush period
       Write Mode : Normal
        Sync Size : 976655360 (931.41 GiB 1000.10 GB)
           Bitmap : 29806 bits (chunks), 10 dirty (0.0%)

Is this to be expected? I would have thought it would say nothing here, 
or say there's no bitmap.

Anyway, continuing my experiment, increasing the bitmap chunk size to 
128MB improves my streaming write throughput even further, to 86MB/s (vs 
45MB/s with the default 2MB chunk, and 81MB/s with a 32MB chunk), but it 
looks like a case of diminishing returns, the chunk size is getting 
large enough to mean there could be real work involved in recovery, and 
I really ought to be testing this with some real filesystem throughput, 
not just streaming writes with dd.

Another `mdadm --grow /dev/md1 --bitmap none` has worked without 
side-effects, but afterwards `mdadm --examine-bitmap` still shows the 
most recent bitmap settings. This is mdadm 2.6.4, or more specifically 
mdadm-2.6.4-1.el5.x86_64.rpm.

I've now gone to a 16MB chunk size, which gives 75MB/s throughput for 
streaming writes to the scratch LV, better than 80% of the bitmap-less 
setup as opposed to less than 50% with the default chunk size, and I 
think I'm going to settle at that for now.

Many thanks for all your advice and assistance.

Cheers,

John.

