From: "John Stoffel" <john@stoffel.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 10:59:50 -0400
Message-ID: <22369.28006.310705.356247@quad.stoffel.home>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
	<22368.45414.256389.605050@quad.stoffel.home>
	<CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
	<57612012.9080902@mpstor.com>
	<CAAkR8+tkvwZneqz2XpwMEqKCXZk=HERXPu9XC0pNX0OZ-AQ8ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAkR8+tkvwZneqz2XpwMEqKCXZk=HERXPu9XC0pNX0OZ-AQ8ZA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>, John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Nicolas" == Nicolas Noble <nicolas@nobis-crew.org> writes:

>> I
>> think in your case you're better off stopping an array that has less than
>> parity drives than it should, either using a udev rule or using mdadm
>> --monitor.

Nicolas> I actually have been unsuccessful in these attempts so far. What
Nicolas> happens is that you very quickly get processes that get indefinitely
Nicolas> stuck (indefinitely as in 'waiting on a very very long kernel
Nicolas> timeout') trying to write something, so that the ext4fs layer becomes
Nicolas> unresponsive on these threads, or take a very long time. Killing the
Nicolas> processes takes a very long time because they are stuck in a kernel
Nicolas> operation. And if potentially more processes can spawn back up, the
Nicolas> automated script starts an interesting game of whack-a-mole in order
Nicolas> to unmount the filesystem.

Nicolas> And you can't stop the underlying arrays without first
Nicolas> stopping the whole chain (umount, stop the lvm volume,
Nicolas> etc...), otherwise you simply get "device is busy" errors,
Nicolas> hence the whack-a-mole process killing. The only working
Nicolas> method I've managed to successfully implement is to
Nicolas> programatically loop over the list of all the drives involved
Nicolas> in the filesystem, on all the raids involved, and flag all of
Nicolas> them as failed drives. This way, you get to really put
Nicolas> "emergency brakes" on. I find that to be a very, very scary
Nicolas> method however.

I think this is the wrong idea.  You do want MD to re-try errors on
underlying devices, because some drives will return an error, and if
MD has long enough timeouts, it can recover and try to re-write the
bad sector(s) on the drive, which early on will let the bad block be
mapped out and new block put in place.

But you're looking for a solution when one device in a stripped RAID0
goes away, what happens to the filesystem then.  And in that case your
shit out of luck.  No filesystem is designed to cope with that type of
failure.

So there might be ext4 or xfs or jfs options which will help you in
this case, but it's not a simple thing to program around.  Esp once
the size of the volume gets really big.

John
