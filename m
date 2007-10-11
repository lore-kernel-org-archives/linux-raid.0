From: Neil Brown <neilb@suse.de>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Fri, 12 Oct 2007 09:51:08 +1000
Message-ID: <18190.46828.156191.300754@notabene.brown>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Thursday October 11
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 11, nagilum@nagilum.org wrote:
> Ok, after looking in "Grow.c" I can see that the backup file is  
> removed once the critial section has passed:
> 
> 		if (backup_file)
> 			unlink(backup_file);
> 
> 		printf(Name ": ... critical section passed.\n");
> 
> Since I had passed that point I'll try to find out where  
> Grow_restart() stumbles. By looking at it I'm not even sure it's able  
> to "resume" and not just restart. :-/
> 

It isn't a problem that you didn't specify a backup-file.
If you don't, mdadm uses some spare space on one of the new drives.
After the critical section has passed, the backup file isn't needed
any longer.
The problem is that mdadm still wants to find and recover from it.

I throughly tested mdadm restarting from a crash during the critical
section, but it looks like I didn't properly test restarting from a
later crash.

I think if you just change the 'return 1' at the end of Grow_restart
to 'return 0' it should work for you.

I'll try to get this fixed properly (and tested) and release a 2.6.4.

NeilBrown
