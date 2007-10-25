From: Neil Brown <neilb@suse.de>
Subject: Re: Raid-10 mount at startup always has problem
Date: Thu, 25 Oct 2007 16:12:15 +1000
Message-ID: <18208.13247.106651.142652@notabene.brown>
References: <46D3147D.2040201@amfes.com>
	<46D49F1A.7030409@tmr.com>
	<46E4A39C.8040509@amfes.com>
	<46E4A5F0.9090407@sauce.co.nz>
	<46E4A7C3.1040902@amfes.com>
	<471F5542.3020504@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel L. Miller on Wednesday October 24
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 24, dmiller@amfes.com wrote:
> Current mdadm.conf:
> DEVICE partitions
> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a auto=part
> 
> still have the problem where on boot one drive is not part of the 
> array.  Is there a log file I can check to find out WHY a drive is not 
> being added?  It's been a while since the reboot, but I did find some 
> entries in dmesg - I'm appending both the md lines and the physical disk 
> related lines.  The bottom shows one disk not being added (this time is 
> was sda) - and the disk that gets skipped on each boot seems to be 
> random - there's no consistent failure:

Odd.... but interesting.
Does it sometimes fail to start the array altogether?

> md: md0 stopped.
> md: md0 stopped.
> md: bind<sdc>
> md: bind<sdd>
> md: bind<sdb>
> md: md0: raid array is not clean -- starting background reconstruction
> raid10: raid set md0 active with 3 out of 4 devices
> md: couldn't update array info. -22
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This is the most surprising line, and hence the one most likely to
convey helpful information.

This message is generated when a process calls "SET_ARRAY_INFO" on an
array that is already running, and the changes implied by the new
"array_info" are not supportable.

The only way I can see this happening is if two copies of "mdadm" are
running at exactly the same time and are both are trying to assemble
the same array.  The first calls SET_ARRAY_INFO and assembles the
(partial) array.  The second calls SET_ARRAY_INFO and gets this error.
Not all devices are included because while when one mdadm when to
look, at a device, the other has it locked and so the first just
ignored it.

I just tried that, and sometimes it worked, but sometimes it assembled
with 3 out of 4 devices.  I didn't get the "couldn't update array info"
message, but that doesn't prove I'm wrong.

I cannot imagine how that might be happening (two at once) unless
maybe 'udev' had been configured to do something as soon as devices
were discovered.... seems unlikely.

It might be worth finding out where mdadm is being run in the init
scripts and add a "-v" flag, and redirecting stdout/stderr to some log
file.
e.g.
   mdadm -As  -v > /var/log/mdadm-$$ 2>&1

And see if that leaves something useful in the log file.

BTW, I don't think your problem has anything to do with the fact that
you are using whole partitions.
While it is debatable whether that is a good idea or not (I like the
idea, but Doug doesn't and I respect his opinion) I doubt it would
contribute to the current problem.


Your description makes me nearly certain that there is some sort of
race going on (that is the easiest way to explain randomly differing
behaviours).   The race is probably between different code 'locking'
(opening with O_EXCL) the various devices.  Give the above error
message, two different 'mdadm's seems most likely, but an mdadm and a
mount-by-label scan could probably do it too.

NeilBrown
