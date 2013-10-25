From: Dag Nygren <dag@newtech.fi>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 14:10:02 +0300
Message-ID: <25143130.q0O8sfG8vl@eseries.newtech.fi>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi> <yq1k3h1d3uk.fsf@sermon.lab.mkp.net>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1k3h1d3uk.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 25 October 2013 06:47:31 Martin K. Petersen wrote:
> >>>>> "Dag" == Dag Nygren <dag@newtech.fi> writes:
> 
> Dag> - What if the md module automatically set this during assembly
> Dag> of the RAID?
> 
> There are a couple of challenges here. libata lives under SCSI and there
> is no official translation between SCTERC for ATA to the SCSI Read Write
> Error Recovery mode page. But I can work around that.
> 
> A harder issue is to ensure that we don't cause regressions by
> requesting the SRWER mode from devices that blow up when they receive an
> unexpected SCSI command (yes, USB device vendors, I'm looking at you).
> 
> Anyway. I agree that this might be worthwhile. I'll put it on my list...

Appreciate that! Would have saved me a lot of work - And I thought I
knew what to do ;-)

Anyway Neil had the opinion that mdadm could do it outside the kernel
and he might be right there. As long as there is no other way to
assemble tha raid but use mdadm.

I do have smoe programming experience myself and could take a look at mdadm
but would probably need some guidance. For example would is be OK to
use an exec(smartctl...) which would make it a very easy programming
exercise or do we then create an unwanted dependency on smartctl.

Best
Dag

