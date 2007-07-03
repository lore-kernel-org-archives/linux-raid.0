From: Simon <simon.xhz@gmail.com>
Subject: Re: spare not becoming active
Date: Tue, 3 Jul 2007 17:54:16 -0500
Message-ID: <f7de5e030707031554y24dbf445k47af7cf4d2b097e8@mail.gmail.com>
References: <4682C9ED.9040503@gmail.com> <4683DC71.3050200@gmail.com>
	 <f7de5e030707031353o14c4a7bbjb2a270646f75fe54@mail.gmail.com>
	 <87bqetjfj5.fsf@hades.wkstn.nix>
	 <f7de5e030707031552s5963b015v6d80c11e853fb71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f7de5e030707031552s5963b015v6d80c11e853fb71@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oups, sorry for the double posts...

> This is normal for a RAID-5 array construction. Rather than force you to
> wait for ages until the RAID parity has been written, mdadm creates a
> degraded two-element array with a single spare and fails over to it; the
> rebuild involved in the failover automatically constructs the parity.

Makes sense.  And i was aware that it was reconstructing...

> > [dev   9,   1] /dev/md1         84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 online
> > [dev   8,  18] /dev/sdb2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
> > [dev   8,  34] /dev/sdc2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 good
> > [dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
> > [dev   8,  50] /dev/sdd2        84AA4AAF.8B2C555E.3F9AE70D.2EEDD5B3 spare
>
> That output is rather strange though, mainly because of the mystic
> missing drive with no name. mdadm bug?

That missing drive is the story of my life with raid!!
You must have missed the previous posts i sent in this thread, where I
was getting one active device and two spare (not being active) and 2
missing drives.  As if the missing drive were taking the spot of an
active one, and the spare waiting could not take that spot.

Well, that's how I understood it, with my noobish mind! ;)

Worst part is that, even though no trace is left on my system after a
reboot (all is written to a tmpfs), even if i was formating the
devices (eg: /dev/sdb2) or using `mdadm --zero-superblock ...` They
were still being created as missing.

Anyway, good news!  After reconstruction the output looks perfect, i
tried soft failing one device and it came back just fine.  Problem was
with a real failure (see first post).

Thanks,
 Simon
