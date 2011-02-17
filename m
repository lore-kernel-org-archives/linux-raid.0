From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 20:43:21 -0600
Message-ID: <4D5C8B49.6050206@hardwarefreak.com>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com> <4D5C7A33.90007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C7A33.90007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil Turmel put forth on 2/16/2011 7:30 PM:
> On 02/16/2011 07:24 PM, Matt Tehonica wrote:
>> Hi all,
>>
>> I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....
> 
> Did you resize (shrink) the XFS filesystem first?

You can't shrink XFS filesystems.

This has been talked about as a possibility in the future, but AFAIK
there's no code yet.

-- 
Stan
