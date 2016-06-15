From: Nicolas Noble <nicolas@nobis-crew.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 02:49:21 -0700
Message-ID: <CAAkR8+tkvwZneqz2XpwMEqKCXZk=HERXPu9XC0pNX0OZ-AQ8ZA@mail.gmail.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
 <22368.45414.256389.605050@quad.stoffel.home> <CAAkR8+vfXJOtYUBvkZXxQhXwh-e2t6yGuarLW4MGS8B+YKtUZg@mail.gmail.com>
 <57612012.9080902@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57612012.9080902@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <ben.estrabaud@mpstor.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I
> think in your case you're better off stopping an array that has less than
> parity drives than it should, either using a udev rule or using mdadm
> --monitor.

I actually have been unsuccessful in these attempts so far. What
happens is that you very quickly get processes that get indefinitely
stuck (indefinitely as in 'waiting on a very very long kernel
timeout') trying to write something, so that the ext4fs layer becomes
unresponsive on these threads, or take a very long time. Killing the
processes takes a very long time because they are stuck in a kernel
operation. And if potentially more processes can spawn back up, the
automated script starts an interesting game of whack-a-mole in order
to unmount the filesystem.

And you can't stop the underlying arrays without first stopping the
whole chain (umount, stop the lvm volume, etc...), otherwise you
simply get "device is busy" errors, hence the whack-a-mole process
killing. The only working method I've managed to successfully
implement is to programatically loop over the list of all the drives
involved in the filesystem, on all the raids involved, and flag all of
them as failed drives. This way, you get to really put "emergency
brakes" on. I find that to be a very, very scary method however.
