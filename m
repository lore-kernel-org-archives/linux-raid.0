From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Know about chunk size
Date: Mon, 26 Nov 2012 16:11:34 -0600
Message-ID: <50B3E916.90205@hardwarefreak.com>
References: <186704.2.1353915309639.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <186704.2.1353915309639.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Kks Kbase <kks.kbase@yahoo.in>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/26/2012 1:35 AM, Roy Sigurd Karlsbakk wrote:
>> I want to know what is best chunk size to create s/w raid devices?
> 
> That depends on the workload, file sizes etc. 

Correct.  And greatly depends on array type.

> The default will probably do fine

This is not true of metadata 1.2 and parity arrays in which case the
default chunk size is 512KB.  That's way too large for anything but
large file streaming workloads.  Most workloads involve metadata and
small files.  This has been discussed previously in detail on this list
and on the XFS list.  For most workloads other than large file
streaming, mirroring+striping is best, but if you must use parity RAID a
small chunk size of 32/64KB yields superior IO performance due to
decreased overhead during RMW.

>> Also is it possible to change the chunk size for an existing array?

No.  You must destroy and recreate it with the new chunk size.  If one
creates an array with an appropriate chunk size there is no need to ever
change it, UNLESS the primary workload hitting the array changes from
random IO to large streaming, or the reverse.  In such a case one
typically builds a new server with a new array, or simply adds a new
array to the existing server for the new workload.  If you are
redeploying the server/array, destroy and recreate with the new optimal
chunk size.

-- 
Stan

