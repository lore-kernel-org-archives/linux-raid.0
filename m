From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Adaptec aacraid
Date: Mon, 15 Mar 2004 09:51:25 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F64E52C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: jlewis@lewis.org, linux-raid@vger.kernel.org
Cc: "Long, Scott" <Scott_Long@adaptec.com>
List-Id: linux-raid.ids

Yes, the backup copy of the initrd is still around, but admittedly the
original aacraid.o modules in the /lib/modules tree are blown away. We
can address this perhaps, by backing up the modules and adding in an
uninstall.sh script to the rpm.

There was much consternation over the rpm's install.sh script. It has to
please too many people.

	rpm --noscripts

-or-

	rpm2cpio

were viewed as the technologically paranoid's way of getting around
this. For the OEMS, technical support, neophytes and those hoping for
plug-n-play, we were requested to make sure all the drivers on the
system were synchronized and up-to-date. This includes *ghasp* a
requirement to also update any trees we find in /lib/modules *even* if
they are not referenced in the boot (grub or lilo) configurations.

Yes, this is functionally similar to a statement `Adaptec knows what is
best for you'. For that I apologize, but you do have a means around all
of this should you feel uncomfortable.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Long, Scott
Sent: Sunday, March 14, 2004 8:00 PM
To: jlewis@lewis.org
Cc: linux-raid@vger.kernel.org
Subject: Re: Adaptec aacraid

. . .

jlewis@lewis.org wrote:
> BTW...as long as someone from Adaptec is here, I have to say I was
> somewhat horrified when during installation of
> aacraid-drv_1.1.4.2323-rh9.rpm (hoping there was a copy of Storage
Manager
> in one of the tar files inside it) the following ran:
> 
>  postinstall scriptlet (using /bin/sh):
>  cd /opt/Adaptec/aacraid.rh9
>  sh ./install.sh
> 
> which appears to have removed the Red Hat kernel RPM provided aacraid
> module for several of the installed kernel rpms, installed its own,
and
> updated initrd files, all without asking/warning.  Fortunately, it
didn't
> have a module for the latest/current kernel, so it didn't mess with
the
> module actually in use.
> 

I'll pass this along to the person who is responsible for the aacraid
RPMs.  I believe that the script is supposed to leave around a backup
of the old modules and initrds.  Did it not in this case?

Scott
