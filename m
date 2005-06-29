From: Mitchell Laks <mlaks@verizon.net>
Subject: mdadm -f ?
Date: Wed, 29 Jun 2005 08:23:09 -0400
Message-ID: <200506290823.09776.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I described  on this list (a few days ago) how I physically removed one of 2 
drives from a raid 1 array. I then took it to another computer to use it as a 
second copy of the data.



That worked fine, although I described at that time that my linux box would  
not boot normally until I ran mdadm -A --run /dev/md0 /dev/hdb1 
with the --run option
as the raid 1 would not start in the degraded state otherwise.

I was wondering. 

imagine I have /dev/md0 composed of /dev/hdb1 and /dev/hdg1

What is the effect  of the command


mdadm --manage /dev/md0 -f /dev/hdg1

Ie: If I "fail" the drive in this way:
1) will the remainder of the array (ie /dev/md0 composed of /dev/hdb1) now 
boot without the --run being added in?
2) Will I still be able to take the drive /dev/hdg1 and use it on another 
machine as a copy of the data from the array?
3) If the  answer to 2 is no, should I do
	a) remove drive /dev/hdg1 physically (machine off)
	b) then after booting without /dev/hdg1 via the --run 
		run the command 	
		mdadm --manage /dev/md0 -f /dev/hdg1 (even though it is  not on the 
machine...
		then will it boot without the --run added in.

thanks,

I am simply not sure of what -f does...

Thanks,

Mitchell 
