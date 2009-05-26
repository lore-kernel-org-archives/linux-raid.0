From: kyle@foobox.homelinux.net
Subject: forcing check of RAID1 arrays causes lockup
Date: Tue, 26 May 2009 19:45:23 -0400
Message-ID: <20090526234523.GB14974@foobox.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings.

In the process of switching distributions on one of my machines, I've 
run into a problem where forcing a check of the RAID arrays causes the 
system to lock up.  I've got a bug open here 
https://bugzilla.redhat.com/show_bug.cgi?id=501126 , but I'm hoping 
someone here can help me track it down.

To add a little more to the last post on that bug, I've since installed 
gentoo, and am running gentoo's patched 2.6.28-gentoo-r5 kernel (along 
with mdadm 2.6.8), and I see the bug here.  I don't follow kernel 
patches, and haven't looked too deeply into the distribution patches, 
but diff isn't showing any changed code in drivers/{md,ata}/* .

And, to further describe "lock up", here's what happens in more detail:
I write "check" to every md array's 'sync_action' file in /sys. 
Within about a second, the system stops responding to user input, 
doesn't update the mouse pointer, doesn't respond to pings.  
I've tried to get in a run of dmesg in before the crash, and I've been 
able to see the usual messages about checking arrays, but that's it.  
Also, I once tried waiting for each array check to finish before 
starting the check to the next array, and that seemed to work for a 
while, but some time late in the several hour process the system locked 
up again.  (It's possible that a cron job tried to start a check--no way 
to know.)

Any ideas?

Thanks,
Kyle Liddell
