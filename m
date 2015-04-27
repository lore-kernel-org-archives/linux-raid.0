From: David Brown <david.brown@hesbynett.no>
Subject: Re: <DKIM> Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 12:54:17 +0200
Message-ID: <553E1559.2010305@hesbynett.no>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <4ADD42F9-407A-4266-A1FC-B92F3D46C36F@insync.za.net> <743316986.23005258.1430129889889.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <743316986.23005258.1430129889889.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>, Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/15 12:18, Jean-Baptiste Thomas wrote:
> On 2015-04-27 20:45 +1200, Pieter De Wit wrote:
> 
>> Sorry for jumping in late - but let's say it does "work" and a
>> drive returns an error, is that data lost ? Or which drive is
>> "right"?
> 
> (Assuming that by "returns an error", you mean succeeds but the
> data does not no match what the other(s) returned.)

The alternative interpretation here is that the drive returns an error
message saying it couldn't read the sector - then it's just standard
RAID (get the data from the other disks).  So we are looking here at the
extremely rare situation where there is an error but the drive (or
controller) does not detect it.

> 
> Let's say there is a setting for how many components must agree.
> If they're not unanimous, read all the other components and look
> for a majority. The components in the minority are flagged
> faulty and the array is degraded but the read succeeds.
> 
> If there is no majority, retry a few times. If a majority is
> found, all components which ever were in the minority are
> flagged faulty and the array is degraded but the read succeeds.
> 
> If no majority is found, degrade all components, fail the read
> and stop the array. Or whatever is needed to prevent all further 
> writes to this array and let the user investigate.

The problem with all of these is that they /might/ be right - but they
/might/ be wrong and make matters worse.  Even if you have 3 copies of
the sector, and get two matches and one different, there is no way to
determine that the odd one is wrong.  Perhaps a common bus or connector
fault caused the other two to be wrong.  Picking the "majority vote" may
decrease your chances of losing data (but may not - it depends on the
cause of the fault), but it certainly does not avoid the worst case
scenario.  Perhaps the best choice during normal usage (as distinct from
recovery or rebuild, when the drive is not mounted) is to simply report
a failure to the layers higher up - that way you won't make matters
worse by giving returning data.


Note that the checksum method (used by btrfs and zfs) is different in
that it lets the system know exactly which copy was bad even if the
drive (and bus and controller) think it was good.


