From: Alvin Oga <aoga@ns.Linux-Consulting.com>
Subject: Re: Getting HD Serial Numbers in RAID
Date: Tue, 31 Aug 2004 13:14:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1040831131338.25589A-100000@Maggie.Linux-Consulting.com>
References: <1093981522.27891.20.camel@afgar.lanl.gov>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1093981522.27891.20.camel@afgar.lanl.gov>
To: "Augustine Ortiz, Jr." <aortizjr@lanl.gov>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-raid.ids


On Tue, 31 Aug 2004, Augustine Ortiz, Jr. wrote:

> Hi...
> 
> I have been working on getting serial numbers electronically off of hard
> drives for various reasons.
> 
> I have been successful with IDE and most SCSI drives (using hdparm and
> scsiinfo). However I am running into trouble with ones that are on
> AACRAID/PERC3 adaptors and actually in a RAID array.
> 
> The only serial number I can seem to grab is the one for the entire
> volume which is just assigned.
> 
> Are there any tools available to get the serial number off the drives in
> the array? Or can I get some pointers on writing such a tool?

hddtemp will get you more info on the disk ... not sure if it works
on aacraid/perc etc

c ya
alvin

