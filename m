From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 20:49:01 -0600
Message-ID: <4F39CB9D.2050500@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/13/2012 3:40 PM, CoolCold wrote:

> While doing this dirty tests, I've seen found that linear md over 3
> subvolumes doesn't support barriers and XFS states this:
> Feb 13 21:39:41 sigma2 kernel: [22336.925917] Filesystem "md6":
> Disabling barriers, trial barrier write failed
> though this doesn't help on iozone random write tests

When using mdraid and a disk controller without BBWC, write barriers
need to be, must be, enabled and working to guarantee journal
consistency.  If barriers are disabled here you're risking the integrity
of the entire filesystem.  Whatever is causing barriers to be disabled
needs to be fixed.  You should definitely ask about this on the XFS
mailing list.  You will want to post your complete mdraid
configuration--the 3 RAID1s and the linear, and your xfs_info output,
and describe the underlying storage hardware--controller(s), disks, etc.
 Maybe Neil might have some insight here as well.

>> I would recommend copying 48k of those actual picture files evenly
>> across 12 directories, for 4K files per dir.  Then use something like
>> curl-loader with a whole lot of simulated clients to hammer on the
>> files.  This allows you to test web server performance and IO
>> performance simultaneously.
> 
> Yes, this will be more realistic, of course.

By far.  Definitely more pain to setup though.  If you can get a
synthetic benchy to batch create the ~50K files randomly across the 12
dirs and then randomly read them out after flushing the caches, that
should be pretty close to real world use as well.

-- 
Stan
