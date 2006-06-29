From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: RAID resync after every boot?
Date: Thu, 29 Jun 2006 17:02:07 +0200
Message-ID: <bb145bd20606290802m4740645bwf733be06f6708d01@mail.gmail.com>
References: <bb145bd20606290205p5f367b5bu8c3051b6fcc4fc51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606290205p5f367b5bu8c3051b6fcc4fc51@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> [...] it seems that it wants to resync on every boot ...

Update:

- During shutdown I got a few errors on the console regarding arrays
that couldn't be stopped, because the mdadm package in Debian tries to
shut down all arrays, even if it is set not to autostart any --> will
file bug.

- The kernel is supposed to shut down md devices (managed by EVMS) on
its own, just before halt / reboot. The last bits of my shutdown
sequence are approximately (this stuff sure goes by fast):

Will now halt.
md: stopping all md devices
md0: still in use
syncing cache of SCSI disk /dev/sda
syncing cache of SCSI disk /dev/sdb
syncing cache of SCSI disk /dev/sdc
syncing cache of SCSI disk /dev/sdd

I don't know what could be using the array at this point, since all
user processes should be dead. Kernel bug? (Kernel is 2.6.17-1-686
from Debian unstable)

- sometimes the array comes up clean after a reboot, especially if it
was never mounted.

Any pointers?

Thanks,

C.
