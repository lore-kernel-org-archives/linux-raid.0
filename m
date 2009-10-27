From: Christian Pernegger <pernegger@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 22:00:07 +0100
Message-ID: <bb145bd20910271400m7d29af2p535c12c784a3b56c@mail.gmail.com>
References: <1256656849.15137.126.camel@poledra.romunt.nl>
	 <472064.4204.qm@web38802.mail.mud.yahoo.com>
	 <7d86ddb90910271339ha3cf796g8fa58b798fd80dfd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90910271339ha3cf796g8fa58b798fd80dfd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>So sine iSCSI is out my next avenue of investigation is clustering filesystems.

Overkill much? Stick with something simple, it will serve you better
in the end, especially when something fails. K.I.S.S., remember?

Just rsync the two boxes already, with or without ssh. That's assuming
the data is mostly static (videos). If you have other data as well you
might want to use rdiff-backup for that, as it can keep multiple
versions.

Get some kind of backplane for the disks so you can swap them out
without powering down the box. (Not because you can't live with 10min
downtime when a disk fails but because you don't want to spin down the
*other* disks.)

Bonus: If the primary server fails but its disks are fine you can just
stick all of them in the backup server temporarily, boot and be up and
running almost immediately.

Cheers,

C.
