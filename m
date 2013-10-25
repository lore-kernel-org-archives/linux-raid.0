From: Dag Nygren <dag@newtech.fi>
Subject: Enable SCTERC in the kernel?
Date: Fri, 25 Oct 2013 11:51 +0300
Message-ID: <1969984.qn2lKzvFd6@eseries.newtech.fi>
Reply-To: dag@newtech.fi
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all!

Just run into the standard problem by not having SCTERC enabled
for my drives due to a spelling mistake in my rc.local script
setting the parameters and started wondering:

- What if the md module automatically set this during assembly
of the RAID? - In the kernel module itself. It could always set it,
if the set failed we could spit out a kernel warning that the used
drive might not be the best as a RAID device. Would there be any ill
effects from this?
- And ditto for the device time-out.

This would definitely make md work a lot better for people. I have a
strange feeling that most don't know the parameter needs setting...

Best
Dag

