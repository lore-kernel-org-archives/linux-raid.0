From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 06:20:36 +0100
Message-ID: <62b0912f0503072120776e0b56@mail.gmail.com>
References: <422D327D.11718.F8DB3@localhost>
	 <200503080414.j284EG510309@www.watkins-home.com>
	 <16941.11443.107607.735855@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.11443.107607.735855@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> It is writes, but don't be scared.  It is just super-block updates.
> 
> In 2.6, the superblock is marked 'clean' whenever there is a period of
> about 20ms of no write activity.  This increases the chance on a
> resync won't be needed after a crash.
> (unfortunately) the superblocks on the spares need to be updated too.

Ack, one of the cool things that a linux md array can do that others
can't is imho that the disks can spin down when inactive.  Granted,
it's mostly for home users who want their desktop RAID to be quiet
when it's not in use, and their basement multi-terabyte facility to
use a minimum of power when idling, but anyway.

Is there any particular reason to update the superblocks every 20
msecs when they're already marked clean?
