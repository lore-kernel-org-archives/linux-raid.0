From: Redeeman <redeeman@metanurb.dk>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Sat, 23 May 2009 01:00:25 +0200
Message-ID: <1243033225.5740.30.camel@localhost>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	 <49ED096E.1000002@anonymous.org.uk>	<49ED16F7.3040906@anonymous.org.uk>
	 <4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
	 <49ED2BC3.7050109@anonymous.org.uk>
	 <18925.24241.19288.797776@notabene.brown>
	 <49EDB685.7000004@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EDB685.7000004@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 2009-04-21 at 13:05 +0100, John Robinson wrote:
> On 21/04/2009 06:50, Neil Brown wrote:
> > On Tuesday April 21, john.robinson@anonymous.org.uk wrote:
> >> Eeek! Trying to `mdadm --grow /dev/md1 --bitmap=none` from my large 
> >> chunk size caused a reboot! There's nothing in the log, and I didn't see 
> >> the console. I still have my 32M chunksize but I don't want to try that 
> >> again in a hurry :-)
> > 
> > That's a worry... I cannot easily reproduce it.  If it happens again
> > and you get any more detail, I'm sure you'll let me know.
> 
> Sure will. For the moment I have something that looks slightly 
> inconsistent: mdadm --detail shows no bitmap after the crash:
> # mdadm --detail /dev/md1
> /dev/md1:
>          Version : 00.90.03
>    Creation Time : Mon Jul 28 15:49:09 2008
>       Raid Level : raid5
>       Array Size : 1953310720 (1862.82 GiB 2000.19 GB)
>    Used Dev Size : 976655360 (931.41 GiB 1000.10 GB)
>     Raid Devices : 3
>    Total Devices : 3
> Preferred Minor : 1
>      Persistence : Superblock is persistent
> 
>      Update Time : Tue Apr 21 12:37:15 2009
>            State : clean
>   Active Devices : 3
> Working Devices : 3
>   Failed Devices : 0
>    Spare Devices : 0
> 
>           Layout : left-symmetric
>       Chunk Size : 256K
> 
>             UUID : d8c57a89:166ee722:23adec48:1574b5fc
>           Events : 0.6152
> 
>      Number   Major   Minor   RaidDevice State
>         0       8        2        0      active sync   /dev/sda2
>         1       8       18        1      active sync   /dev/sdb2
>         2       8       34        2      active sync   /dev/sdc2
> 
> and indeed another attempt to remove the bitmap fails gently:
> # mdadm --grow /dev/md1 --bitmap none
> mdadm: no bitmap found on /dev/md1
> 
> However examining any of the devices making up the RAID appears to 
> suggest there is a bitmap:
> # mdadm --examine-bitmap /dev/sda2
>          Filename : /dev/sda2
>             Magic : 6d746962
>           Version : 4
>              UUID : d8c57a89:166ee722:23adec48:1574b5fc
>            Events : 6148
>    Events Cleared : 6148
>             State : OK
>         Chunksize : 32 MB
>            Daemon : 5s flush period
>        Write Mode : Normal
>         Sync Size : 976655360 (931.41 GiB 1000.10 GB)
>            Bitmap : 29806 bits (chunks), 10 dirty (0.0%)
> 
> Is this to be expected? I would have thought it would say nothing here, 
> or say there's no bitmap.

Hmm very good question, I'd like to know that aswell..

<snip>
> Many thanks for all your advice and assistance.
> 
> Cheers,
> 
> John.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

