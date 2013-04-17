From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 14:45:14 +1000
Message-ID: <516E28DA.7070102@websitemanagers.com.au>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org> <516DFC4F.5000908@websitemanagers.com.au> <516E24C8.9080803@tigertech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516E24C8.9080803@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/04/13 14:27, Robert L Mathews wrote:
> But complete disk death doesn't seem to be the normal failure mode. If
> the failure is spurious, as so many seem to be, and temporarily
> affects an array so that each disk has a different event count, that
> isn't a disaster under RAID 1. If worst comes to worst, you can pick
> one disk to use and pretend RAID doesn't even exist. You don't need to
> get the members to successfully sync into an array to read the data.
> But if each disk in a RAID 5 or RAID 6 array gets a different event
> count, or if the disks refuse to easily assemble into an active array
> for any other reason, all your data is inaccessible until you fix the
> RAID problem. I avidly read the details of every RAID 5 [and 6]
> disaster on the list, and almost every one would be trivially easy to
> fix under RAID 1, with no risk of complete data loss. It's heartbreaking. 
RAID1 of course fails the requirement of a single filesystem that
requires more space than a single disk can provide.

Of course, you can then consider LVM2, multiple mount points, or RAID10
or RAID1 + linear etc.... but most people still prefer to see a single
block device. Dealing with multiple RAID1 and a linear could lead to
more complex issues as well.

In any case, as mentioned previously, the majority of issues are caused
by mis-configuration, if we could add some configuration verification to
mdadm or similar, then we might be able to warn more people prior to
things failing.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

