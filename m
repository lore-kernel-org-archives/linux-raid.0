From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid5 with 2 bad drives
Date: Tue, 22 Feb 2005 17:03:05 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502221656160.4157@lion.drogon.net>
References: <u650k4kbd.fsf@julius-net.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <u650k4kbd.fsf@julius-net.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Julius <matthias.julius@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2005, Matthias Julius wrote:

> Hi,
>
> I have a raid5 out of 4 drives where 2 drives failed and were
> removed.  Since it happened during backup I would very much like to
> reactivate the array to rescue as much data as there are intact.
>
> When I try to assemble the array with mdadm it tells me that there are
> not enough devices.  Is there a way to convince mdadm to use the
> faulty drive to get a working array?

Try something like:

  mdadm --assemble /dev/mdY /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 \
	--run --force

Substitute the mdY and the /dev/sd?? for your devices as appropriate..

As for getting the data off, you have to be carefull you don't hit the bad
blocks again.. You might be able to mount it read-only, then tar up the
filesystem, directory at a time, hoping you don't hit a bad-block inside a
file.

Gordon


