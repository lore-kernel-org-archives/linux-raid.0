From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Sat, 13 Nov 2004 21:54:10 +0000
Message-ID: <41968282.6060306@dgreaves.com>
References: <200411132039.iADKdDN07474@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411132039.iADKdDN07474@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

>Sorry, the command should be:
>mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/hdb1
>
>Hope that helps.
>
>Guy
>  
>
Yep.

My fault though - no excuses - I should know this stuff and should have 
checked more carefully.

It's been a fraught day and coming back to take the server apart, screw 
it back together etc etc made me sloppy.

Anyway. The good news is that I let the 2nd dd_rescue finish - typed in 
the command *with* a raid device to work on (doh!) and it worked.

Then I started lvm and that worked.

Then I tried to run xfs_check on the smaller (350Gb) partition - 
oomkiller time.
<Sigh>, nothing's easy is it.
I have 256Mb of RAM and 512Mb swap - I've stopped all other daemons - 
and still it dies...

And to think one of my tasks in all this was to merge the two 
filesystems into one and use xfs rather than reiserfs3.6 - but xfs won't 
even fsck!!!

OK, off to yank some RAM from another machine...

Thanks for the help guys - I appreciate it.

Is there a wiki for mdadm, raid around? I'd like to contribute to it (so 
I can use it next time <grin>)

David
