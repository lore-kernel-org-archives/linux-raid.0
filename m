From: Scott Long <scott_long@adaptec.com>
Subject: Re: Adaptec aacraid
Date: Sun, 14 Mar 2004 18:00:00 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40550010.1020603@adaptec.com>
References: <Pine.LNX.4.58.0403141803560.1969@web1.mmaero.com> <4054F4EA.8050805@adaptec.com> <Pine.LNX.4.58.0403141930000.1969@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0403141930000.1969@web1.mmaero.com>
To: jlewis@lewis.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

jlewis@lewis.org wrote:
> On Sun, 14 Mar 2004, Scott Long wrote:
> 
>  > jlewis@lewis.org wrote:
>  > > I've been hunting around on adaptec's web site, but I haven't found 
> it.
>  > > Is there a raidutil package (Storage Manager) that supports the 2200S?
>  > > I'd like to be able to manage the arrays and query for drive 
> information
>  > > without taking the system down.
>  >
>  > The 2200S comes with both a command line and GUI app for managing
>  > the card under Linux.  It should be on the CD that came with the card.
> 
> I'll have to see if I can get someone to put that CD in.  The server in
> question is >100 miles away and was setup remotely.  Is there a reason the
> software isn't online?...or did I just fail to find it?
> 

Try this:

http://www.adaptec.com/worldwide/support/driverdetail.html?sess=no&language=English+US&cat=/Product/AAR-2810SA&filekey=asmbe_linux_v1.23.006.tgz

This is from the 2810SA download page, but should work fine for the
2200S.  I'm not sure why the apps packages are not posted for linux
in the 2200S section.


> BTW...as long as someone from Adaptec is here, I have to say I was
> somewhat horrified when during installation of
> aacraid-drv_1.1.4.2323-rh9.rpm (hoping there was a copy of Storage Manager
> in one of the tar files inside it) the following ran:
> 
>  postinstall scriptlet (using /bin/sh):
>  cd /opt/Adaptec/aacraid.rh9
>  sh ./install.sh
> 
> which appears to have removed the Red Hat kernel RPM provided aacraid
> module for several of the installed kernel rpms, installed its own, and
> updated initrd files, all without asking/warning.  Fortunately, it didn't
> have a module for the latest/current kernel, so it didn't mess with the
> module actually in use.
> 

I'll pass this along to the person who is responsible for the aacraid
RPMs.  I believe that the script is supposed to leave around a backup
of the old modules and initrds.  Did it not in this case?

Scott

