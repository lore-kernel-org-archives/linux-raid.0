From: Fabrice LORRAIN <Fabrice.Lorrain@univ-mlv.fr>
Subject: Re: mdadm drives me crazy
Date: Wed, 01 Dec 2004 13:53:26 +0100
Message-ID: <41ADBEC6.8030701@univ-mlv.fr>
References: <41ADA964.3030606@univ-mlv.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41ADA964.3030606@univ-mlv.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Fabrice.Lorrain@univ-mlv.fr
List-Id: linux-raid.ids

Fabrice LORRAIN wrote:
> Hi all,
> 
...
> $ sudo mdadm --create /dev/md0 --level=5 --raid-devices=6 /dev/loop[0-5]


$ sudo mdadm --create /dev/md0 --force --level=5 --raid-devices=6 
/dev/loop[0-5]

Seems to give what I expected (a raid5 pool with 6 devices, no spare).

 From mdadm man page :
"...When creating a RAID5 array, mdadm will automatically create a 
degraded array with an extra spare drive.  This is because building the 
spare into a  degraded  array  is in general faster than resyncing the 
parity on a non-degraded, but not clean, array.  This feature can be 
over-ridden with the -I --force option."

"-I" doesn't seems to be understood by mdadm. Leftover ?

I don't understand what the previous extract from the man page means. My 
understanding is that the default behaviour of mdadm is to create a 
raid5 pool in degraded mode aka with a missing drive ? Is this correct ?

after
$ sudo mdadm --create /dev/md0 --force --level=5 --raid-devices=6 
/dev/loop[0-5]

the state of the array is dirty. Why ?

$ sudo mdadm --stop /dev/md0 followed by
$ sudo mdadm --examine /dev/loop[0-5]

gives a clean state for each device but

$ sudo mdadm --assemble /dev/md0 /dev/loop[0-5] keeps the dirty state of 
the array.

Thanks,

	Fab
