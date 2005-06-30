From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Thu, 30 Jun 2005 13:05:05 -0500
Message-ID: <42C43451.5030904@dynaconnections.com>
References: <Pine.LNX.4.44.0506291027460.26718-100000@firewall2.tmr.com> <Pine.LNX.4.58.0506290918380.799@lewis.et.byu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0506290918380.799@lewis.et.byu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: David Dougall <davidd@et.byu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Dougall wrote:

>reads from a Raid1 md device will always round-robin between
>the devices to increase performance.
>
If it was round-robin that would actually decrease the performance, it's 
locality based.  It reads from the RAID member that last operated in the 
physical vicinity of the requested data to be read.  ie it minimize the 
distance disk heads have to move.  This is one way RAID1 lowers average 
seek time.

-ryan
