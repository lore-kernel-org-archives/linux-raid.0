From: Duncan Hill <dhill+linuxraid@cricalix.net>
Subject: Re: Gigabyte GA-7N400 Pro2 and raid
Date: Thu, 29 Apr 2004 07:18:27 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404290718.27213.dhill+linuxraid@cricalix.net>
References: <000901c42da1$bdbc8610$6705a8c0@a30> <200404290638.44608.dhill@cricalix.net> <000d01c42dad$a2073530$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000d01c42dad$a2073530$6705a8c0@a30>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 29 April 2004 06:48, me@heyjay.com wrote:
> Duncan,
>
> It is ITE 8212 (I'm not sure if it is an "F" though).  The driver for
> RedHat and Mandrake are available on giga-byte.com.  When you say I'm out
> of luck, what exactly does that mean?

Well, let me spin my tale of woe :)

I have a GA K8N-Pro board, with the ITE 8212F RAID chipset.  Combined with the 
SATA connectors and the regular IDE, I can use 10 drives - in theory.  I did 
a 32 bit FC1 install using the regular IDE drives, and then hooked up a pair 
of 120 GB drives to the RAID controller.  Loaded the driver from ite.com.tw, 
and watched it do all sorts of funny things.  Shrugged, powered down and 
removed the 120s.

Fast forward a month or so, and I have the machine in the UK now (bought it in 
the US).  Running Gentoo64, runs like a charm.  Decide to poke the ITE driver 
again, this time under the 2.6 kernel.  Had even worse results (search the 
Gentoo AMD 64 forum and you'll see other people having issues).  Have tossed 
several logs at ITE, once I managed to convince them that they wrote the 
driver (!), seeing as it had their copyright on it.

For a 2.4 series kernel, under 32 bit, you may have more luck than I have had.  
If I had more of a clue about drivers for kernels (and C in general), I'd 
tackle this and make the driver work.  I don't, so I can't, unless I can 
convince someone other than ITE to scratch the itch.

References:
http://www.cricalix.net/ite.log  - my most recent debug log of trying the 
driver.  Note the 0 byte sector size and and lack of cache info.  This was 
one of my better days with the driver.

http://forums.gentoo.org/viewtopic.php?t=165932  - someone claiming that AMD's 
porting notes helped.  I love his -1 sector size.

http://forums.gentoo.org/viewtopic.php?t=155095  - other people (including 
self) having issues.

http://www.uwsg.iu.edu/hypermail/linux/kernel/0310.3/1187.html  - someone on 
lkml who doesn't think much of the driver.  And that spinlock is still there 
in the latest release - not knowing much about kernel module designs, I don't 
know if he's right or wrong.
