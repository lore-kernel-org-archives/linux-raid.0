From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Good news / bad news - The joys of RAID
Date: Tue, 23 Nov 2004 15:33:07 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0411231529120.17251@lion.drogon.net>
References: <200411222348.iAMNmJN01404@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411222348.iAMNmJN01404@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Nov 2004, Guy wrote:

> Amanda...
> I looked into this about 2 years ago.  From what I found, each daily backup
> used a different tape.  This is crazy!  I can put 10-20 days on 1 tape.
> Maybe more, not really sure.  Of course it is based on how much data changes
> each day.  So, my full backups are only needed about once every 2-3 weeks.
>
> Since Amanda uses up too many tapes, I use a home grown set of scripts that
> maintain the tape position and use cpio for the backup.
>
> Do you know if the above is true about Amanda?

Yes. Amanda uses one tape per backup. It writes a label at the start of
every tape to make sure it's writing the backup to the right tape.

With your system, if you lose one tape, you lose a lot of backups
(however, I have a client who uses one removable disk and I store multiple
backups on that disk)...

> About tape age.  I know of a system that has DLT tapes that are over 7 years
> old.  They have 21 tape drives total in 7 tape juke boxes.  No idea about
> the number of tapes, but well over 4000.  These very in age from less than 1
> year to over 7 years old.  They also have 2 copies of all data.  So, if a
> tape fails, just find the copy.  Also make a new copy to maintain 2 copies.

As long as they remember to take a set of tapes out of the jukebox from
time to time and replace with fresh :)

Gordon
