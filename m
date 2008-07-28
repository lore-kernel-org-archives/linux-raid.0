From: Brad <brad46526@gmail.com>
Subject: Re: System hangs on raid md recovery/resync
Date: Mon, 28 Jul 2008 20:05:13 +1000
Message-ID: <da290bd50807280305q44f5d127ofe98add826298ef5@mail.gmail.com>
References: <da290bd50807260519v293851c9ue4bef88b1fc52013@mail.gmail.com>
	 <da290bd50807271505k4bf5734bp9734883a219e9d53@mail.gmail.com>
	 <488CF4F5.9030707@gmail.com>
	 <da290bd50807271639o1dd585edwe121c156743a4199@mail.gmail.com>
	 <488D0E04.3000505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <488D0E04.3000505@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roger,

> The Intel stuff tends to be pretty decent, where I have ran into the most
> issues is with anything that the MB vendor adds on, so I would try putting
> all 3 on the Intel, and in the past the Intel controllers I have tested have
> been able to run all disks at full speed (or close to it) even when multiple
> disks are being actively used, this would at least eliminate the jmicron
> controller from the mix.

I thought I was being cute in putting the two disks of the regular raid1
set on different controllers, for maximum redundancy.  :-)  But yes, the
JMicron controller seems to be a bit flakey ... sometimes after a reboot it will
experience constant 'hard resetting link' errors under full load.  After another
reboot though it'll be as stable as a rock.  I've assumed Linux isn't getting
something quite right when it initialises the JMicron controller at boot.

In any case I've noticed - using iostat - that when I've added the third drive
to the raid1 device, for example, the recover operation consists of reads on
the disk that's hooked up to the ICH9R controller and writes to the third
disk on the same controller.  The MD code doesn't seem to share the read
operation between the two existing mirrored disks, so the second disk on
the JMicron isn't involved at all.

> How much power does the PS have on the 12V line?    So long as it is either
> a split 12V supply or has more than 15-20A (non-split PS) you should be OK.

I'm sorry but I wouldn't have a clue about that.  I've got an Antec
Sonata III 500
case with its standard 500W power suppler.  "80 PLUS" certified, whatever
that means ... "an EarthWatts 500 Watt power supply unit (PSU) which is
equipped with universal input and Active PFC. This PSU is also 80PLUS(R)
certified making it one of the most efficient PSU's available" says their web
site.

> You did run the dd on all 3 disks at the same time?

Yes.

> The hard resetting link usually indicates something bad happened, though
> that could be caused by a lot of things.

I normally never see that error at all.  And I didn't see it the three times the
system hung on the MD raid1 resync/recover operations.

If the kernel MD code had a hardware problem with the SATA 2 ports would
I see an error message?


Brad
