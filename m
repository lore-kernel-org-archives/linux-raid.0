From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 21:27:52 -0700
Message-ID: <516E24C8.9080803@tigertech.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org> <516DFC4F.5000908@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DFC4F.5000908@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/13 6:35 PM, Adam Goryachev wrote:

> Obviously, if they suffered a two disk [RAID 1] failure then they won't
> be here asking for help will they :)

Heh. Well, no, they won't if the disks are completely and permanently dead.

(I know I'm starting to sound like a broken record, but "that's partly
why we use three disks instead of two and make sure they don't all use
the same company's firmware".)

But complete disk death doesn't seem to be the normal failure mode.
If the failure is spurious, as so many seem to be, and temporarily
affects an array so that each disk has a different event count, that
isn't a disaster under RAID 1. If worst comes to worst, you can pick one
disk to use and pretend RAID doesn't even exist. You don't need to get
the members to successfully sync into an array to read the data.

But if each disk in a RAID 5 or RAID 6 array gets a different event
count, or if the disks refuse to easily assemble into an active array
for any other reason, all your data is inaccessible until you fix the
RAID problem.

I avidly read the details of every RAID 5 [and 6] disaster on the list,
and almost every one would be trivially easy to fix under RAID 1, with
no risk of complete data loss. It's heartbreaking.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
