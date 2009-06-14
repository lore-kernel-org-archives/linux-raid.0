From: Kyler Laird <kyler-keyword-linuxraid.6e1399@lairds.com>
Subject: Re: "cannot start dirty degraded array"
Date: Sun, 14 Jun 2009 19:56:28 -0400
Message-ID: <20090614235627.GI18313@lairds.com>
References: <20090610200310.GF18313@lairds.com> <18997.34950.565094.141137@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18997.34950.565094.141137@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 14, 2009 at 08:32:22PM -0300, Carlos Carvalho wrote:

> You can try to use mdadm -A -f /dev/md2 <list of devices> to force the
> array to assemble. Should work if all disks stopped simultaneously.

I appreciate your response, Carlos.  I did try that before sending the
machine for recovery.  We're now working with a service that seems good
to me.  Here's their initial report.
	Md0; is made up of the first 16 physical drives, and the first 8
	drives are out of sync with the second eight.  Event codes are
	incorrect.  It appears that someone tried to start the raid (as
	in force) with only eight drives.  This raid will not reassemble
	without fixing the superblock hex structure and getting it back
	into alignment.

	Md1; is made up of the next 16 physical drives.  The first 8
	drives think the second set of 8 are faulty, but the event codes
	are OK.

	Md2; is made up of the last set of 16 physical drives.  The
	first two drives in this array think that everything is OK, but
	all the other drives show all manner of faults and drive removals.
$36K for standard recovery.  We're still working on it.

The drives all appear to be alright.  I suspect that there was a
kernel/controller problem.

Thank you.

--kyler
