From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: recovering after a /dev/sda failure on raid1
Date: Tue, 6 Aug 2002 12:51:11 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A664702CD66C2@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Louis-David Mitterrand' <ldm@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I would agree about Fujitsu, Hitachi, & Seagate SCSI disks being very
reliable.

Do note that the server-class drives should have consistent mode page
settings and firmware levels from the vendor.  Fixes to most early-life disk
problems boil down to changes to either the firmware or the mode page
settings.  Even the IBM problems can be helped significantly by upgrading
firmware and careful mode page settings.  

There are DOS utilities to check/update these, and I have some tools for
Linux to help check or update disk firmware and mode pages, if you are
interested.
http://cvs.carrierlinux.org/viewcvs/viewcvs.cgi/components/scsirastools/src/

Andy Cress

On Mon, Aug 05, 2002 at 12:35:47PM -0600, Maurice Hilarius wrote:
> The Fujitsu disks have a track record of good reliability.
> The IDE disk you mention were discontinued a year ago.
> In our experiences Fujitsu disks have as low a failure rate as can be
found.
> Drives we have used with higher failure rates (SCSI) came from IBM and 
> Seagate.
> The best failure rate we have seen is from Hitachi.
> In the case of Fujitsu, Hitachi, and Seagate the rates are very close.
> Quantum/Maxtor SCSI are a bit worse.
> IBM are substantially worse.
> This is based on our DOA and in service SCSI disk failures over the past 
> year.


