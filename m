From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 03 Feb 2005 10:07:28 -0800
Message-ID: <42026860.1000409@zytor.com>
References: <200502031743.j13Hha910546@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502031743.j13Hha910546@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Ruth Ivimey-Cook' <Ruth.Ivimey-Cook@ivimey.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Would you say that the 2.6 Kernel is suitable for storing mission-critical
> data, then?

Sure.  I'd trust 2.6 over 2.4 at this point.

> I ask because I have read about a lot of problems with data corruption and
> oops on this list and the SCSI list.  But in most or all cases the 2.4
> Kernel does not have the same problem.

I haven't seen any problems like that, including on kernel.org, which is 
definitely a high demand site.

> Who out there has a RAID6 array that they believe is stable and safe?
> And please give some details about the array.  Number of disks, sizes, LVM,
> FS, SCSI, ATA and anything else you can think of?  Also, details about any
> disk failures and how well recovery went?

The one I have is a 6-disk ATA array (6x250 GB), ext3.  Had one disk 
failure which hasn't been replaced yet; it's successfully running in 
1-disk degraded mode.

I'll let other people speak for themselves.

	-hpa
