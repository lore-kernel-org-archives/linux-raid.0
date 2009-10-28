From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: RE: Is My Data DESTROYED?!
Date: Wed, 28 Oct 2009 03:57:33 +0100
Message-ID: <1256698653.15137.148.camel@poledra.romunt.nl>
References: <20091028003918054.PKIA6016@cdptpa-omta03.mail.rr.com>
Reply-To: Rudy@grumpydevil.homelinux.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091028003918054.PKIA6016@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Op dinsdag 27-10-2009 om 19:39 uur [tijdzone -0500], schreef Leslie
Rhorer:
> > Just rsync the two boxes already, with or without ssh. That's assuming
> > the data is mostly static (videos). If you have other data as well you
> > might want to use rdiff-backup for that, as it can keep multiple
> > versions.
> > 
> > Get some kind of backplane for the disks so you can swap them out
> > without powering down the box. (Not because you can't live with 10min
> > downtime when a disk fails but because you don't want to spin down the
> > *other* disks.)
> > 
> > Bonus: If the primary server fails but its disks are fine you can just
> > stick all of them in the backup server temporarily, boot and be up and
> > running almost immediately.
> 
> 	Well, depending on the system and exactly what dies, it may be
> simpler just to fix or replace the server.  The big bonus comes when the
> primary array fails, though.  If the OS files and directories (/boot, /etc,
> /var, /home, etc.) are all on a separate drive system and the primary array
> contains only application data, then upon total failure of the primary
> array, one may simply umount the main array and use NFS to temporarily mount
> the remote file system wherever the primary array used to be.  The entire
> production system is then up and running as usual, while the sysadmin
> figures out what the heck went wrong with the primary array.  When the array
> is fixed, an rsync (hopefully a brief one) can copy all the new / changed
> files to the main array.  Then umount the NFS share and mount the main array
> again.
> 

Agreed. Just a pity the OP thinks NFS is useless old bloadware.... 

Rudy

