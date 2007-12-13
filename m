From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm break / restore soft mirror
Date: Thu, 13 Dec 2007 17:45:09 -0500
Message-ID: <4761B5F5.3000505@tmr.com>
References: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05ED21952E28E94E8352836547A6BA37042318B3@achmsx001.hsa.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Maton <Brett.Maton@simplyhealth.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brett Maton wrote:
> Hi, 
>
>   Question for you guys. 
>
>   A brief history: 
>   RHEL 4 AS 
>   I have a partition with way to many small files on (Usually around a couple of million) that needs to be backed up, standard
>
>   methods mean that a restore is impossibly slow due to the sheer volume of files. 
>   Solution, raw backup /restore of the device.  However the partition is permanently being accessed. 
>
>   Proposed solution is to use software raid mirror.  Before backup starts, break the soft mirror unmount and backup partition
>
>   restore soft mirror and let it resync / rebuild itself. 
>
>   Would the above intentional break/fix of the mirror cause any problems? 
>   

Probably. If by "accessed" you mean read-only, you can do this, but if 
the data is changing you have a serious problem that the data on the 
disk and queued in memory may leave that part on the disk as an 
inconsistent data set. If there is a means of backing up a set of files 
which are changing other than stopping the updates in a known valid 
state, it's not something which I've seen really work in all cases.

DM has some snapshot capabilities, but in fact they have the same 
limitation, the data on a partition can be backed up, but unless you can 
ensure that the data is in a consistent state when it's frozen, your 
backup will have some small possibility of failure. Database programs 
have ways to freeze the data to do backups, but if an application 
doesn't have a means to force the data on the disk valid, it will only 
be a "pretty good" backup.

I suggest looking at things like rsync, which will not solve the 
changing data problem, but may do the backup quickly enough to be as 
useful as what you propose. Of course a full backup is likely to take a 
long time however you do it.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


