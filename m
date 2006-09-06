From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Care and feeding of RAID?
Date: Wed, 6 Sep 2006 01:04:03 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0609060101030.27973@lion.drogon.net>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net>
 <44FD91D1.7090501@maine.edu> <Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
 <44FDB80A.50606@waldoware.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FDB80A.50606@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 5 Sep 2006, Paul Waldo wrote:

> Gordon Henderson wrote:
> > On Tue, 5 Sep 2006, Steve Cousins wrote:
> [snip]
> > and my weekly badblocks script looks like:
> >
> > #!/bin/csh
> >
> > echo "`uname -n`: Badblocks test starting at [`date`]"
> >
> > foreach disk ( a c )
> >   foreach partition ( 1 2 3 5 6 )
> >     echo -n "hd$disk${partition}: "
> >     badblocks -c 128 /dev/hd$disk$partition
> >   end
> >   echo ""
> > end
> >
> > echo "`uname -n`: Badblocks test   ending at [`date`]"
> [snip]
>
> Maybe I'm missing something, but are these partitions mounted?  Here's what I
> get when I do this on a mounted partition:
>
> [root@paul ~]# badblocks -nsv /dev/md0
> /dev/md0 is mounted; it's not safe to run badblocks!

Do not use the -n option... (and -s won't be much use in a cron job, nor
-v, probably!) -n will write to the device which might well have issues
with the filesystem cache...

By reading the underlying drives you won't trigger a raid array failure
should you do see a bad sector, which might give you time to go something
about it. There was some emails on this list some time back (year or 2,3?)
about badblocking the md? device - I imagine it might not read every block
of every device unless it was a raid-0 array...

Gordon
