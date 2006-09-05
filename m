From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Care and feeding of RAID?
Date: Tue, 05 Sep 2006 13:46:50 -0400
Message-ID: <44FDB80A.50606@waldoware.com>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> On Tue, 5 Sep 2006, Steve Cousins wrote:
[snip]
> and my weekly badblocks script looks like:
> 
> #!/bin/csh
> 
> echo "`uname -n`: Badblocks test starting at [`date`]"
> 
> foreach disk ( a c )
>   foreach partition ( 1 2 3 5 6 )
>     echo -n "hd$disk${partition}: "
>     badblocks -c 128 /dev/hd$disk$partition
>   end
>   echo ""
> end
> 
> echo "`uname -n`: Badblocks test   ending at [`date`]"
[snip]

Maybe I'm missing something, but are these partitions mounted?  Here's what I 
get when I do this on a mounted partition:

[root@paul ~]# badblocks -nsv /dev/md0
/dev/md0 is mounted; it's not safe to run badblocks!

If you are running RAID, is it safe to run badblocks on the underlying partition?
