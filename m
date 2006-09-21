From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: USB disks for RAID storage (was Re: Please help me save my data)
Date: Thu, 21 Sep 2006 07:25:01 +0200
Message-ID: <62b0912f0609202225qdc710eap2c566e25a7e4bd8a@mail.gmail.com>
References: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
	 <b53b67d20609110610v5d4a63a9ube77d918b0406484@mail.gmail.com>
	 <87odtfe5l7.fsf_-_@rimspace.net>
	 <62b0912f0609180143y7fb3f9d6m7024c41edb709bcd@mail.gmail.com>
	 <b53b67d20609190259v44d7306bya61a487fd055888b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b53b67d20609190259v44d7306bya61a487fd055888b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Patrick Hoover <phoover.eml@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patrick Hoover wrote:
> However, in this case, where SMART doesn't appear to work,
> what are the best options for monitoring disk integrity / degradation?

echo check > /sys/block/mdX/md/sync_action

AFAIK, using the above, MD will "repair" bad blocks and kick disks if it fails.
A failed repair means the spare area is full and the disk desperately
needs a replacement.

Having a spare disk in the array is probably a good idea too, to
minimize downtime, especially if you're not able to get to the machine
all the time.  I don't know if MD checks spares for read errors,
though that would definitely be useful.

Monitoring for kicked disks can be done by running mdadm in daemon
mode with --monitor, having it send you an email when such an event
occurs.

Something that I've found useful is to "dd if=/dev/hdX of=/dev/null
bs=1M count=512".  If there is a problem in the IDE driver, or the
cable is loose, or there is a controller problem, the disk might
respond, but will fail as soon as you read a large amount of data.
I've also seen disks succeed to read some amount of data, but at a
significantly lower rate than it should.  Monitoring the read rates of
each disk can be helpful (at least it is to me) to diagnose such
problems.
