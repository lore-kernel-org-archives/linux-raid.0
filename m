From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID 6 initial sync very slow
Date: Mon, 02 Jun 2008 08:35:09 -0400
Message-ID: <4843E8FD.8000601@tmr.com>
References: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CA91F18992AC9E-1724-EAF@webmail-ne13.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thomas62186218@aol.com wrote:
> Hi all,
>
> I am debating between hardware or software RAID for a high-performance 
> Linux storage server. One area of concern in my initial mdadm tests 
> concerns sync speed. My setup is as follows:
>
> Linux Fedora 7 x64
> 12 x 1TB Hitachi 1TB SATAII drives connected via LSI SAS3801E PCIe HBA
> Dual 2.5GHz quad-core Xeon
> 8GB RAM
>
> My first test was to create a RAID 6 md device, 128K chunk, with all 
> 12 drives. The sync is currently underway at a very slow 30MB/sec, 
> with mdadm estimating this as a 9hr process. With an Adaptec 5805 RAID 
> card tested, I performed the RAID 6 initial sync with the same 12 
> drives in just under 5 hours. Meanwhile, our total CPU usage during 
> mdadm syncing is at 5%, so there's plenty of CPU not being used.
>
> Why is the sync so slow? This concerns me not only because initial 
> sync time is important, but because this may be indicative of slow 
> sync times in the event of a drive failure.

Two things will limit this, chunk size and max speed set in the 
/sys/block/mdNN/md/sync_speed_max setting. What you are seeing does 
sound slow.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


