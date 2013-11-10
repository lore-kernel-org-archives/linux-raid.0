From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Running check and e2fsck simultaneously
Date: Sun, 10 Nov 2013 14:12:10 -0600
Message-ID: <527FE89A.4010608@hardwarefreak.com>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/2013 1:35 PM, Ivan Lezhnjov IV wrote:
> 
> On Nov 10, 2013, at 9:17 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> 
>> On 11/10/2013 12:12 PM, Ivan Lezhnjov IV wrote:
>>> Love for optimization :) I'm going to run check via cron job, and then I thought why not run e2fsck on the same day so that I do all the maintenance on the same day (in my configuration check requires some almost 48 hours for this raid1 2TB array when filesystem is mounted but it can run in foreground and results examined later, while e2fsck obviously requires some attention).
>>
>> This is not optimization.  This is unnecessary duplication of sanity
>> checking of on-disk data structures.
>>
>> No journaling filesystem requires scheduled "preemptive" metadata
>> structure checking, not EXT3/4, XFS, nor JFS.  If there is a problem
>> they will alert you in the logs before your scheduled check runs.  Then
>> you run a check/repair manually.  You mentioned e2fsck so I assume you
>> have EXT3 or 4.
>>
> 
> While this is true, it may help to understand where I'm coming from with this idea. See, my array is connected over USB to a laptop. I have no intention of frequently disconnecting the drives, but I run a hybrid desktop/server Linux system, meaning that the laptop runs X, and I connect over VNC and all, but it also runs some typical server services such as FTP, HTTP, SAMBA, NFS, etc. I send this computer to sleep mode every night and resume next morning and pm-utils does not always work as expected, and I think it adversely affects any externally connected storage device as it may sometimes go to sleep without proper unmount action (in those rare cases when something happens to the system, it does happen, rarely, but it does). So, it is reasonable to run e2fsck from time to time to catch
  those not very obvious failures and to correct any possible impact.

Now you know why I asked for context.  Your original post suggested you
were doing something very different, out of the ordinary.  And you most
certainly are.

USB is not a storage protocol.  USB devices often disconnect/reconnect
for no apparent reason.  We see this frequently with the little vendor
USB disk drives (Seagate/WD) and also generic disk enclosures.  USB is
not a proper protocol for md/RAID storage.  You may have continual
problems with this setup.

If the laptop has an eSATA port use eSATA.  If not, drop in an eSATA
PCMCIA card.  This should be much more reliable than USB for this
application.

>> Also, I see little/no value in running a scheduled mdadm check on a
>> RAID1 array.  Any problems with RAID1 will be due to one of the disks
>> beginning to fail in some mode, usually requiring sector relocation.
>> Most drives do this automatically until they run out of spare sectors,
>> at which point md will throw write errors.  Monitoring SMART data and/or
>> running SMART self analysis on a schedule is much more effective here,
>> as you will become aware of a problem sooner, and have the opportunity
>> to correct it before it shows up in md.
> 
> Bare with me, I know very little about how RAID works so I can sometimes make totally absurd statements. That being said, I intend to monitor SMART values and I'm wondering now why does it make sense to run check on other types of RAID? I assume 5/6/10 mostly?
> 
> I'm also wondering if it is advised to run check with filesystem mounted and in use, or unmounted?

Instead of using a connection method known to cause problems with
storage, and then attempting to mitigate such damage with array/fs
checks after the fact, why not simply avoid the problem in the first
place?  Use eSATA, or build/buy a little NFS/Samba NAS filer.

-- 
Stan

