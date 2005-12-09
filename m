From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm source rpm build error + command-line parsing error + resync
 reporting problem
Date: Fri, 9 Dec 2005 16:33:14 +1100
Message-ID: <17305.5914.446708.235858@cse.unsw.edu.au>
References: <4399121F.9060906@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Hardy on Thursday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday December 8, mhardy@h3c.com wrote:
> 
> I got this when I attempted to rpmbuild -ba mdadm.spec:
> ------------------------
> 
> In file included from super0.c:31:
> /usr/include/asm/byteorder.h:6:2: error: #warning using private kernel
> header; include <endian.h> instead!
> make: *** [super0.o] Error 1
> error: Bad exit status from /var/tmp/rpm-tmp.64960 (%build)
> 
> 
> RPM build errors:
>     Bad exit status from /var/tmp/rpm-tmp.64960 (%build)
> [root@istanbul ~]# uname -a
> Linux istanbul.tacitknowledge.com 2.6.14-1.1644_FC4smp #1 SMP Sun Nov 27
> 03:39:31 EST 2005 i686 i686 i386 GNU/Linux
> [root@istanbul ~]# cat /etc/redhat-release
> Fedora Core release 4 (Stentz)
> 

Yes... redhat have done something silly (I think).
<endian.h> simply doesn't contain the stuff that I need from
byteorder.h.

I wonder if there is some #define I can stick in there to trick
byteorder.h into not complaining....


> --------------------------
> 
> This occurs for the files super0.c, super1.c, and bitmap.c.
> 
> If you remove the -Werror flag from the Makefile, it works though it
> still generates warnings.

That's easier to do now, you can just

   mdadm CWFLAGS=

and it won't bother so much about warnings.

> 
> I installed the new version of mdadm in the hopes that it would improve
> the situation with the grow mode commandline parsing, which was broken
> in the 1.11 that FC4 ships. Alas, it did not:
> 
> [root@istanbul redhat]# mdadm -G /dev/md1
> mdadm: no changes to --grow
> [root@istanbul redhat]# mdadm -G /dev/md1 --size
> mdadm: option `--size' requires an argument
> 
> The man page indicates that if I don't set the size, it will grow to
> fill the smallest device in the array. It's definitely not doing
> that...

Could you please point me to the part of the man page that says that?
I will try to fix it.

> 
> I read mdadm.c, and see that 'max' is the argument that mdadm is looking
> for, but the man page isn't mentioning.

Hmmm.. I can find it in the man page - look at the section on --size
(but then, I know where to look...)
You are the first person with this problem, so maybe I need to make it
more explicit.

> 
> Finally, and I think was reported once before, but I don't recall a
> resolution for it, I got this once I specified that it grow to maximum size:
> 
> [root@istanbul mdadm-2.1]# cat /proc/mdstat
> Personalities : [raid1]
> md2 : active raid1 sdb1[0] sda1[1]
>       98176 blocks [2/2] [UU]
> 
> md1 : active raid1 sdb3[0] sda3[1]
>       70573440 blocks [2/2] [UU]
>       [=========>...........]  resync = 49.9% (35220224/70573440)
> finish=0.2min speed=2515730K/sec
> 
> md0 : active raid1 sdb2[0] sda2[1]
>       977856 blocks [2/2] [UU]
> 
> unused devices: <none>
> 
> This is a dual Xeon (so it looks like a 4-CPU machine). Not sure what's
> causing that though...

You mean the excessive speed? 
The accounting assumes that it is resyncing every block.  When it
doesn't have to do that, it gets it a bit wrong... I'll look into it.

Thanks for the reports,
NeilBrown
