From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 18:30:27 +0000
Message-ID: <41950143.5000105@dgreaves.com>
References: <200411121809.iACI9kN01098@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411121809.iACI9kN01098@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
