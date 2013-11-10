From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 13:17:21 -0600
Message-ID: <527FDBC1.4000009@hardwarefreak.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2013 12:12 PM, Ivan Lezhnjov IV wrote:
> Love for optimization :) I'm going to run check via cron job, and then I thought why not run e2fsck on the same day so that I do all the maintenance on the same day (in my configuration check requires some almost 48 hours for this raid1 2TB array when filesystem is mounted but it can run in foreground and results examined later, while e2fsck obviously requires some attention).

This is not optimization.  This is unnecessary duplication of sanity
checking of on-disk data structures.

No journaling filesystem requires scheduled "preemptive" metadata
structure checking, not EXT3/4, XFS, nor JFS.  If there is a problem
they will alert you in the logs before your scheduled check runs.  Then
you run a check/repair manually.  You mentioned e2fsck so I assume you
have EXT3 or 4.

Also, I see little/no value in running a scheduled mdadm check on a
RAID1 array.  Any problems with RAID1 will be due to one of the disks
beginning to fail in some mode, usually requiring sector relocation.
Most drives do this automatically until they run out of spare sectors,
at which point md will throw write errors.  Monitoring SMART data and/or
running SMART self analysis on a schedule is much more effective here,
as you will become aware of a problem sooner, and have the opportunity
to correct it before it shows up in md.

> On Nov 10, 2013, at 8:08 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 11/10/2013 10:06 AM, Ivan Lezhnjov IV wrote:
>>> Is this a good idea to run check and e2fsck on raid1 simultaneously? I'm leaning towards a definitive no, but then again I don't really know.
>>
>> A more critical question is what current circumstances have prompted you
>> to consider this?
>>
>> -- 
>> Stan
