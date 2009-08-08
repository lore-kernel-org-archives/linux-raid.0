From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Draft Mirrored Linux Mini How-to - sfdisk suggestion
Date: Sat, 08 Aug 2009 03:13:23 +0200
Message-ID: <87r5vnp0p8.fsf@frosties.localdomain>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>
	<4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>
	<4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
	<4A7B708F.4050406@uga.edu> <4A7C47DF.3000307@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7C47DF.3000307@harddata.com> (Maurice Hilarius's message of
	"Fri, 07 Aug 2009 09:27:27 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: harold@uga.edu, vger majordomo for lists <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Maurice Hilarius <maurice@harddata.com> writes:

> Harold Pritchett wrote:
>> Following this note is a draft of a "Mirrored Linux Mini How-to"
>> document.
>> ..
>> To ensure that the partitions are correct, and in the correct order,
>> boot from
>> the install CD/DVD and run the rescue system.  Use fdisk from this system
>> to partition the two drives.
>> ..
>> In the event of a disk failure, follow the below procedure.
>> ..
>> 10. Bring up the system and use fdisk to partition the new drive EXACTLY
>>     the same as the existing drive.
>
> I suggest that the steps involving partitioning multiple drives are
> prone to error.
>
> I offer that the use sfdisk is more accurate, and user friendly.
>
> By using sfdisk with the -d option we can get a dump of the current
> partition table in a regular file,
> and if needed we can restore it from that file.
>
> Example:
>
> |	sfdisk -d /dev/sda | sfdisk /dev/sdb
>
> This is a very simple way to duplicate the partition table from one disk to another.
>
> |

ACK. I do that too.

Now we only need the same thing directly in the installer.

MfG
        Goswin
