From: Adam Luter <luterac@bellsouth.net>
Subject: Re: RAID backup
Date: Thu, 3 Oct 2002 08:40:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021003134034.GC15338@smeagol>
References: <200210031120.g93BKLqK000216@darkstar.example.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210031120.g93BKLqK000216@darkstar.example.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You would still have to mount -o remount,ro while doing this...

I'd just tape backup the actual files.  Then you can use that backup
on something other than the same raid cluster/disks.  Also, you don't
have to backup everything (such as /usr), unless you want to/can
afford to.

-Gryn (Adam Luter)

On Thu, Oct 03, 2002 at 12:20:21PM +0100, jbradford@dial.pipex.com wrote:
> Might it not be a good idea to DD the raw contents of each disk to a
tape drive, just incase you fubar the array?  It would be time
consuming, but at least you could restore your data in the event that
it gets corrupted.
> 
> John.
