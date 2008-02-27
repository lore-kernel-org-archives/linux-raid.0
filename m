From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: very poor ext3 write performance on big filesystems?
Date: Wed, 27 Feb 2008 21:25:49 +0100
Message-ID: <47C5C74D.3050508@wpkg.org>
References: <47B980AC.2080806@wpkg.org> <p7363wmxsxr.fsf@bingen.suse.de> <20080218141640.GC12568@mit.edu> <47C54773.4040402@wpkg.org> <20080227200335.GB9331@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080227200335.GB9331@webber.adilger.int>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>, LKML <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andreas Dilger schrieb:
> I'm CCing the linux-raid mailing list, since I suspect they will be
> interested in this result.
> 
> I would suspect that the "journal guided RAID recovery" mechanism
> developed by U.Wisconsin may significantly benefit this workload
> because the filesystem journal is already recording all of these
> block numbers and the MD bitmap mechanism is pure overhead.

Also, using anticipatory IO scheduler seems to be the best option for an 
array with lots of seeks and random reads and writes (quite 
surprisingly, closely followed by NOOP - both were behaving much better 
than deadline or CFQ).

Here are some numbers I posted to BackupPC mailing list:

http://thread.gmane.org/gmane.comp.sysutils.backup.backuppc.general/14009



-- 
Tomasz Chmielewski
http://wpkg.org
