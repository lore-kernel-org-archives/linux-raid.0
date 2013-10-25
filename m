From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 06:47:31 -0400
Message-ID: <yq1k3h1d3uk.fsf@sermon.lab.mkp.net>
References: <1969984.qn2lKzvFd6@eseries.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1969984.qn2lKzvFd6@eseries.newtech.fi> (Dag Nygren's message of
	"Fri, 25 Oct 2013 11:51 +0300")
Sender: linux-raid-owner@vger.kernel.org
To: dag@newtech.fi
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Dag" == Dag Nygren <dag@newtech.fi> writes:

Dag> - What if the md module automatically set this during assembly
Dag> of the RAID?

There are a couple of challenges here. libata lives under SCSI and there
is no official translation between SCTERC for ATA to the SCSI Read Write
Error Recovery mode page. But I can work around that.

A harder issue is to ensure that we don't cause regressions by
requesting the SRWER mode from devices that blow up when they receive an
unexpected SCSI command (yes, USB device vendors, I'm looking at you).

Anyway. I agree that this might be worthwhile. I'll put it on my list...

-- 
Martin K. Petersen	Oracle Linux Engineering
