From: anthony mayes <anmayes@siue.edu>
Subject: Re: raid0 + raid1 question
Date: Thu, 09 Oct 2003 16:00:11 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F85CC5B.5020107@siue.edu>
References: <3F84793F.6060400@siue.edu> <1065729282.10027.127.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1065729282.10027.127.camel@localhost.localdomain>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rechenberg, Andrew wrote:

>We actually used to backup our data in this fashion, but we used a
>triple mirror.  We had three hardware RAID arrays and then we used Linux
>software RAID to mirror those three (i.e. /dev/hdc1, /dev/hdd1, and
>/dev/hde1).  At night we used mdadm to break the mirror, mount the
>removed partition and backup, and then add the partition back in and
>re-mirror.
>
Exactly what we do now.

>The database is unavailable for less than 1 minute while the snapshot is
>taken (it actually takes less than 10 seconds to snapshot ~360GB, the
>other time is just the script sleeping, making sure all transactions
>complete).  This solution ensures a consistent database, while also
>having near-line backups available on disk.
>
I'm assuming the snapshot it the same size as the FS to backup.  What if 
you don't have enough disk space to do this?

-- 
Anthony Mayes
UNIX Server Administration
Southern Illinois University Edwardsville
anmayes@siue.edu


