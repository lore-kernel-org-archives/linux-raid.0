From: Jonas Nickel <jonas.nickel@tu-berlin.de>
Subject: Re: Filesystem did not grow with my RAID 5 array
Date: Tue, 22 Oct 2002 18:14:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210221813.56115.jonas.nickel@tu-berlin.de>
References: <200210221632.09276.jonas.nickel@tu-berlin.de> <20021022144657.GD25163@smeagol>
Reply-To: jonas.nickel@tu-berlin.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021022144657.GD25163@smeagol>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday, 22. Oktober 2002 16:46 Adam Luter wrote:
> You need to use a e2fs resize program in addition to the raid reconf
> program.  The latter only changed the size of the device (i.e.
> /dev/md0), and the former will change the size of the filesystem -on-
> the device to fill the new size.
>
> -Gryn (Adam Luter)

Thanks, that did the job.

Jonas

