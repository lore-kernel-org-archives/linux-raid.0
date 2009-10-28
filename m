From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 19:39:11 -0500
Message-ID: <20091028003918054.PKIA6016@cdptpa-omta03.mail.rr.com>
References: <bb145bd20910271400m7d29af2p535c12c784a3b56c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20910271400m7d29af2p535c12c784a3b56c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Just rsync the two boxes already, with or without ssh. That's assuming
> the data is mostly static (videos). If you have other data as well you
> might want to use rdiff-backup for that, as it can keep multiple
> versions.
> 
> Get some kind of backplane for the disks so you can swap them out
> without powering down the box. (Not because you can't live with 10min
> downtime when a disk fails but because you don't want to spin down the
> *other* disks.)
> 
> Bonus: If the primary server fails but its disks are fine you can just
> stick all of them in the backup server temporarily, boot and be up and
> running almost immediately.

	Well, depending on the system and exactly what dies, it may be
simpler just to fix or replace the server.  The big bonus comes when the
primary array fails, though.  If the OS files and directories (/boot, /etc,
/var, /home, etc.) are all on a separate drive system and the primary array
contains only application data, then upon total failure of the primary
array, one may simply umount the main array and use NFS to temporarily mount
the remote file system wherever the primary array used to be.  The entire
production system is then up and running as usual, while the sysadmin
figures out what the heck went wrong with the primary array.  When the array
is fixed, an rsync (hopefully a brief one) can copy all the new / changed
files to the main array.  Then umount the NFS share and mount the main array
again.

