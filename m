From: Petter Reinholdtsen <pere@hungry.com>
Subject: Re: Help with recovering resized raid where machine crashed while PENDING
Date: Tue, 5 Jul 2011 18:24:33 +0200
Message-ID: <20110705162433.GB18875@login1.uio.no>
References: <2flfwmpdpw2.fsf@login1.uio.no> <20110705104923.4779e295@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110705104923.4779e295@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Neil Brown]
> I probably wouldn't have helped.  It is supposed to write backup
> stuff to the spares and if it didn't do that, it probably wouldn't
> have written it to a file either.

Right.  Is this a bug or the way it is supposed to work?

> The easiest fix for now is to recreate the array.
> 
> mdadm -CR /dev/md3 --metadata=0.90 -n3 -l5 -c64 /dev/sdb2 /dev/sdc2
> /dev/sdf2 --assume-clean
>
> should do it.

Thank you.  How did you determine which devices to use and which order
to list them in?  I've since rebooted and want to make sure I do not
pick the wrong devices.

> Then if that looks good, add the extra devices and grow the array
> again.

Will try when md2 is done growing tomorrow. :)

Happy hacking,
-- 
Petter Reinholdtsen
