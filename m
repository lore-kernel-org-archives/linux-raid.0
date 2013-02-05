From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Tue, 05 Feb 2013 08:17:09 -0600
Message-ID: <51111465.8080603@hardwarefreak.com>
References: <733670.23.1360022484693.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <733670.23.1360022484693.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/4/2013 6:01 PM, Roy Sigurd Karlsbakk wrote:
>> Third, use XFS, and format with alignment to the md device:
>> ~$ mkfs.xfs -d su=512k,sw=4
> 
> Why? ext4 should be just as good for that, 

XFS generally yields better performance with concurrency, and is simply
a better filesystem across the board WRT performance, features, and
tools.  And XFS has been designed and optimized since 1994 specifically
for storing and streaming large files, making it a perfect fit for the
OP's 4GB files.

Why use "just as good" when one can use the best?

> and better for metadata

XFS metadata performance has exceeded that of EXT4 since mainline kernel
2.6.39 (May 2011) for workloads with medium to large concurrency (2-4
threads or more).  It's single thread metadata performance is now not
far behind EXT4.  Thus journal metadata performance is no longer a
reason to avoid XFS.

Regardless, metadata performance is irrelevant to the OP's stated workload.

-- 
Stan

