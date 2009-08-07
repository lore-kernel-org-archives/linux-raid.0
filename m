From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Draft Mirrored Linux Mini How-to - sfdisk suggestion
Date: Fri, 07 Aug 2009 09:27:27 -0600
Message-ID: <4A7C47DF.3000307@harddata.com>
References: <4A78292A.5000607@in.ibm.com>	 <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com>	 <1249465934.18245.54.camel@pasglop>  <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop> <4A7B708F.4050406@uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7B708F.4050406@uga.edu>
Sender: linux-raid-owner@vger.kernel.org
To: harold@uga.edu, vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Harold Pritchett wrote:
> Following this note is a draft of a "Mirrored Linux Mini How-to" 
> document.
> ..
> To ensure that the partitions are correct, and in the correct order, 
> boot from
> the install CD/DVD and run the rescue system.  Use fdisk from this system
> to partition the two drives.
> ..
> In the event of a disk failure, follow the below procedure.
> ..
> 10. Bring up the system and use fdisk to partition the new drive EXACTLY
>     the same as the existing drive.

I suggest that the steps involving partitioning multiple drives are 
prone to error.

I offer that the use sfdisk is more accurate, and user friendly.

By using sfdisk with the -d option we can get a dump of the current 
partition table in a regular file,
and if needed we can restore it from that file.

Example:

|	sfdisk -d /dev/sda | sfdisk /dev/sdb

This is a very simple way to duplicate the partition table from one disk to another.

|


-- 
Regards, Maurice
