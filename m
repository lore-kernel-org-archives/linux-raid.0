From: berk walker <berk.walker@verizon.net>
Subject: Re: raid5, media scans and stripe-wise resync
Date: Tue, 26 Oct 2004 05:56:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <417E1F5A.5020902@verizon.net>
References: <1098718593.5399.29.camel@duxeon.cobite.com> <e9132f82041025123926140ece@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9132f82041025123926140ece@mail.gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

One problem with doing a surface scan which writes and reads back the 
data is that in the event of weak/worn media, the data can appear to be 
good, but degrade quickly (mag fields go soft).  Just my own 2 cents, 
but the sick fella should be shot and buried immediately, no second chances.
b-

Bruce Lowekamp wrote:

>There was a recent conversation on this mailing list about
>transparently recovering from read errors (essentially just rewriting
>the bad stripe and letting the disk handle it), but I think it focused
>on Raid 1.  It would be a natural for Raid 5 or 6, but I haven't seen
>an experimental patch to do that.
>
>If you just want to monitor, look at http://smartmontools.sourceforge.net
>each of the drives in my array has a montoring config:
>/dev/hda -a -o on -S on -R 194 -s (S/../.././02|L/../../6/07) -m
>lowekamp@cs.wm.edu
>
>two weeks ago I got email that one disk had a bad read on a sector
>during its weekly long scan (an entire surface scan).  I failed that
>drive manually, waited until it resynced on the spare, overwrote the
>entire drive to let the drive clear the sector (and make sure there
>weren't any other problems), then reran the test and set that drive as
>the spare.
>
>I'd still feel safer if it automatically overwrote only the sector
>with the read error, but at least this way I knew that the other 9
>drives had passed a surface scan just before, so I wasn't likely to
>run into a second read failure on rebuild.
>
>Bruce
>
>
>On Mon, 25 Oct 2004 11:36:33 -0400, David Mansfield <md@dm.cobite.com> wrote:
>  
>
>>Hi everyone,
>>
>>After a few recent severe raid failures (one linux md, one 3ware), my
>>understanding and fear about linux md is greatly increased.  Single
>>sector unrecoverable errors are doing us in!
>>
>>To alleviate these fears, we (my coworkers and I) believe we need to
>>start a policy of conducting a 'background media scan' of the actual
>>underlying physical devices in a raid 5.  This is easily accomplished on
>>the 3ware (it's built in), but we are struggling with linux md.
>>
>>A utility called SCU, http://www.bit-net.com/%7Ermiller/scu.html, will
>>allow us to scan the media, and, if necessary, reassign the bad blocks.
>>We have used this on scsi disks before, it seems to work, as a lowlevel
>>tool.
>>
>>However! If two bad blocks are discovered on two different disks in the
>>raid 5 (even if the bad blocks are in different stripes), we will be
>>screwed, because the raid system will kick out the disk immediately when
>>the first bad sector is found, and then reconstruction will fail when
>>the second bad sector is found.  screwed.
>>
>>Which brings me (finally) to my questions:
>>
>>1) does linux md have a plan for integrating background media scanning
>>and automatic sector reassignment like hardware solutions have?
>>
>>2) how can we force (or manually perform) a stripe-wise resync? is it
>>possible to take the raid offline completely, read the data with dd,
>>compute the parity manually, reassign the bad block using SCU and
>>rewrite the parity block with dd then put the raid online again?
>>
>>If #2 is possible, I'm sure a quick-and-dirty perl script could be
>>created to do the work, which I'd be happy to do, if it's theoretically
>>doable.
>>
>>Thanks,
>>David
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>    
>>
>
>
>  
>

