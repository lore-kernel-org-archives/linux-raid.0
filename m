From: =?ISO-8859-2?Q?Giedrius_Statkevi=E8ius?=
	<giedrius.statkevicius@gmail.com>
Subject: Re: 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke cryptsetup on my
 machine
Date: Sat, 10 Oct 2015 15:44:49 +0300 (EEST)
Message-ID: <alpine.LNX.2.20.1510101543410.1998@localhost.localdomain>
References: <alpine.LNX.2.20.1510072226180.1350@localhost.localdomain> <20151008123849.GA4279@ubuntu>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-917664247-1444481095=:1998"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151008123849.GA4279@ubuntu>
Sender: linux-kernel-owner@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Cc: =?ISO-8859-2?Q?Giedrius_Statkevi=E8ius?= <giedrius.statkevicius@gmail.com>, snitzer <snitzer@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-917664247-1444481095=:1998
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 8 Oct 2015, Geliang Tang wrote:

> On Wed, Oct 07, 2015 at 10:27:27PM +0300, Giedrius Statkevičius wrote:
> > Hello,
> > I have a LUKS on LVM setup: /boot is unencrypted and everything is "hidden" in
> > /dev/sda2. After booting on linux-next and just after entering my password
> > cryptsetup segfaults and a stack trace is printed from the kernel. Since writing
> > down all those numbers is hard I've made a picture where it is shown:
> > https://i.imgur.com/6PHNUdv.jpg
> > 
> > I figured it had something to do with changes to memory management and thus find
> > out that commit 30c2a1faaeb3db94fc92f79553cc72634aa3b218 broke my system.
> > Reverting it there is no such error anymore and system boots fine past that
> > point. 
> > 
> > Could someone look into this? Thanks, Giedrius
> 
> Bugfix for this has been sended out.
> https://lkml.org/lkml/2015/10/8/342.
> 
> Thanks.
I've tested and that fixed this issue for me. I would've replied on that thread
but I can't find its Message-Id. Anyway, you can add:
Tested-By: Giedrius Statkevičius <giedrius.statkevicius@gmail.com>

Thanks,
Giedrius
--8323328-917664247-1444481095=:1998--
