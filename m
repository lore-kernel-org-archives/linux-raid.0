From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: telling mdadm to use spare drive.
Date: Wed, 07 Nov 2007 10:17:51 +0100
Message-ID: <87bqa6jtxc.fsf@informatik.uni-tuebingen.de>
References: <20071104170502.6db7fcb1@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071104170502.6db7fcb1@absurd> (Janek Kozicki's message of
	"Sun, 4 Nov 2007 17:05:02 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki <janek_listy@wp.pl> writes:

> Hi,
>
> I finished copying all data from old disc hdc to my shiny new
> RAID5 array (/dev/hda3 /dev/sda3 missing). Next step is to create a
> partition on hdc and add it to the array. And so I did this:
>
> # mdadm --add /dev/md1 /dev/hdc3
>
> But then I had a problem - the /dev/hdc3 was a spare, it didn't
> resync automatically:

Strange. That is exactly how I always do it and it always just worked.
mdadm should start syncing on any spare as soon as a disk fails or you
add the spare to a degraded array afaik. No special "start now"
interaction needed.

MfG
        Goswin
