From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 3 Feb 2005 12:43:31 -0500
Message-ID: <200502031743.j13Hha910546@www.watkins-home.com>
References: <420253CD.9010505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <420253CD.9010505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'H. Peter Anvin'" <hpa@zytor.com>, 'Ruth Ivimey-Cook' <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Would you say that the 2.6 Kernel is suitable for storing mission-critical
data, then?

I ask because I have read about a lot of problems with data corruption and
oops on this list and the SCSI list.  But in most or all cases the 2.4
Kernel does not have the same problem.

Who out there has a RAID6 array that they believe is stable and safe?
And please give some details about the array.  Number of disks, sizes, LVM,
FS, SCSI, ATA and anything else you can think of?  Also, details about any
disk failures and how well recovery went?

Thanks,
Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of H. Peter Anvin
Sent: Thursday, February 03, 2005 11:40 AM
To: Ruth Ivimey-Cook
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem

Ruth Ivimey-Cook wrote:
> 
> Would you say that raid-6 is suitable for storing mission-critical data,
then?
> 

What I'd say is that I don't have any evidence it's not.  Unfortunately, 
that's not quite the same thing.

> I have a .5TB raid5 array on 5 IDE disks, and given what has been said
recently
> about disk MTBF's and RAID failure recovery, I'm thinking it might be best
to
> switch to raid-6.
> 
> I guess such a switch is best implemented as {make backup, reformat,
restore},
> if I went ahead?

Yes, right now there is no RAID5->RAID6 conversion tool that I know of.

	-hpa
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

