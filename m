From: Neil Brown <neilb@suse.de>
Subject: Re: Preventing a RAID device from starting until all disks are
 ready
Date: Fri, 15 Oct 2010 12:54:48 +1100
Message-ID: <20101015125448.2c0f7592@notabene>
References: <385159.62204.qm@web65412.mail.ac4.yahoo.com>
	<4CB7292A.6040209@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CB7292A.6040209@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: Andrew Klaassen <clawsoon@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Oct 2010 12:00:42 -0400
Iordan Iordanov <iordan@cdf.toronto.edu> wrote:

> Hi Andrew,
> 
> Andrew Klaassen wrote:
> > During boot, mdadm starts the array before one of the two fibre-channel cards has started its disk detection.  The array comes up, but with only 28 of 56 drives, and I have to manually re-add the drives and cross my fingers that nothing will go wrong during the 10-hour rebuild.
> 
> Have you considered enabling a write-intent bitmap on your array? This 
> way, at least your rebuild will take seconds instead of 10 hours. Write 
> intent bitmap support for RAID10 was introduced in 2005, and hopefully 
> CentOS 5.2 supports it.
> 
> > Is there any way to tell mdadm to wait longer, or to not attempt to start the array if not all devices are present, or... (any other solution you can think of)?
> 
> We have iscsi targets for drives in our array, and we make sure that 
> we've logged into all 30 of our drives before we continue to enable 
> mdadm (we literally count the number of iscsi sessions open). You can 
> try counting the number of block devices present (in /dev/block) that 
> match a certain pattern, or perhaps your fiber channel driver offers an 
> even more convenient facility in /dev.
> 
> However, it would be great if there really was a way to tell mdadm to 
> wait until the devices are ready. I'm not aware of one though.
> 

Time to go back and read the mdadm man page.  From top to bottom.  Twice.

I suspect that --no-degraded is the flag you want.\

It was introduced in mdadm 2.5

There are three scenarios that could be relevant.

1/ If an array is being assembled explicitly, e.g.
   mdadm --assemble /dev/mdX .....
 then mdadm will refuse to assemble the array if any expected devices are
 missing.  You need to add "--run" to get it to start a partial array.

2/ If an array is being assembled using auto-assembly, e.g.
   mdadm --assemble --scan
 then mdadm will start partial arrays if it cannot find the missing parts
 anyway.  You can tell it not to with --no-degraded.  This flag is actually a
 misnomer.  It may well assemble a degraded array, but only if the array was
 degraded the last time it was active.

3/ If an array is being assembled used a sequence of --incremental commands,
e.g.
   mdadm --incremental /dev/first
   mdadm --incremental /dev/second
  etc

 then mdadm won't assemble the array until all expected devices have been
 found.  Using "--run" will override this so the array is assembled as soon
 as enough devices are present.  Once all possible devices have been
 presented to mdadm it "mdadm -incremental device" you can tell mdadm to
 start any arrays that haven't been started yet with
   mdadm --incremental --run

Hope that clears it up.

NeilBrown

