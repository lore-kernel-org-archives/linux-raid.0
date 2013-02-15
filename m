From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Best practice for large storage?
Date: Fri, 15 Feb 2013 10:51:22 +0100
Message-ID: <511E051A.9080004@profitbricks.com>
References: <9702021.20.1360863570996.JavaMail.root@zimbra> <511D235C.6070409@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511D235C.6070409@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14.02.2013 18:48, Jeff Johnson wrote:
> Stable enough where it is being used at Lawrence Livermore Nat'l Labs on
> a 55PB Lustre resource.
> 
> I've been using it on a pre-release Lustre 2.4 and I have not had any
> issues.

ZFS completely fragments if you've got massive parallel write IO -
especially with Solaris 11. You'll get only 2..3 MiB/s after some time
as everything is stored completely random then. So if you don't really
need these snapshots you shouldn't use ZFS. NILFS is also good for
snapshots.

> On 2/14/13 9:39 AM, Roy Sigurd Karlsbakk wrote:
>> I don't feel like using the fuse version, but is zfsonlinux really
>> stable yet?
>>
>> ----- Opprinnelig melding -----
>>> Roy,
>>>
>>> Why not use ZFS on Linux? (http://www.zfsonlinux.org)
>>>
>>> ZFS on Linux is being merged into the upcoming Lustre 2.4 parallel
>>> filesystem release.
>>>
>>> --Jeff

