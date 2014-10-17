From: "John Stoffel" <john@stoffel.org>
Subject: Re: I will pay money for the correct RAID recovery instructions
Date: Fri, 17 Oct 2014 10:05:40 -0400
Message-ID: <21569.8756.823611.71332@quad.stoffel.home>
References: <CANs+QMz3jNpAneHLzN5c=EtK+RAOhQJZy=n3P0oYTRm7yNDzjg@mail.gmail.com>
	<20141016202202.GA22898@cthulhu.home.robinhill.me.uk>
	<CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANs+QMy7d+kAxazgdk_r+iPtK45+ddSMwEQg6M_6e4giqJgJmw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Young <ian@duffrecords.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Ian,

It would also help if you posted the details of your setup using:

cat /proc/partitions
cat /proc/mdstat

mdadm -D /dev/md#
 - for each of the devices above.

mdadm -E /dev/sd<drive><#>
 - for each disk or partition in the array from above.



But the suggestions to ddrescue the going bad drive onto a new disk is
a good one.  On my debian system, I would do the following:

  sudo apt-get install gddrescue
  ddrescue /dev/sde /dev/sdf /var/tmp/ddrecue-sde.log

and see how that goes.  

Good luck,
John
