From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 13:47:18 -0500
Message-ID: <200411121847.iACIlNN01272@www.watkins-home.com>
References: <41950143.5000105@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41950143.5000105@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Greaves' <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes a reboot is needed to correct the problem.  Unless you can figure out
how to stop the array.

Guy

-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Friday, November 12, 2004 1:30 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA

Guy wrote:

>NO!!!!!
>
>Bad plan, but almost correct.
>If you "--add" a disk, md would think it is a new disk.  And none of the
>existing data would be used.  The array would not start anyway.  But if you
>use the instructions below, you should get your array back to normal.
>  
>
OK, that's encouraging :)

>+ Stop array:
>+ "mdadm /dev/md0 -S"
>  
>
mdadm: fail to stop array /dev/md0: Device or resource busy
Basically they're still mounted and can't unmount 'cos the nfsds are 
running.

Is a reboot the right thing? (back into single user)

David

