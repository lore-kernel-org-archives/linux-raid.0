From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Is my raid setup speed ok?!
Date: Wed, 19 Nov 2003 11:49:23 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311191649.hAJGnTE25045@www.watkins-home.com>
References: <PPEOJEIEFLAONFNHJPOOMEILGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOMEILGOAA.jim@jimtreats.com>
To: 'James R Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Each time you re-boot.

It's not a fix.  It's just changing a default.  If your system ran too slow
during a re-build, you would want to lower the number.

As I understand it, this limits the data rate to each disk.  Since you had 2
disks, you were getting 20000K per second of disk i/o.

It would be nice if /proc/mdstat would display the current min and max speed
limits.  It would also be nice if there was a place you could set them just
once.  Maybe /etc/raidtab.  Maybe a new file /etc/md.conf.  I would prefer
to have an overall throughput speed limit, and a per array group speed
limit.  The overall throughput speed limit would not be per disk, but total
disk i/o.

Guy

-----Original Message-----
From: James R Bamford [mailto:jim@jimtreats.com] 
Sent: Wednesday, November 19, 2003 8:57 AM
To: Guy; 'James R Bamford'; linux-raid@vger.kernel.org
Subject: RE: Is my raid setup speed ok?!

> -----Original Message-----
> From: Guy [mailto:bugzilla@watkins-home.com]
> Sent: 19 November 2003 04:10
> To: 'James R Bamford'; linux-raid@vger.kernel.org
> Subject: RE: Is my raid setup speed ok?!
>
>
> It may be too late for this re-sync, but in the future do this:
> echo 100000 > /proc/sys/dev/raid/speed_limit_max
>
> The default speed limit is 10000, that's what you are getting.
> So you have reached a software imposed limit, not a hardware limit.
>
>

Thanks.. I wondered about this.. it could really do with being added into
the HOWTO..

Is this fix a do once.. fix everytime.. or something that i have to do each
time i plan to rebuild an array.. (isn't proc deleted every boot!? so
someone has asked me...)

Thanks tho

Jim


