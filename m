From: rob <rob@fantinibakery.com>
Subject: Re: missing superblock on RAID5
Date: Mon, 13 Oct 2003 20:18:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B40F3.2080004@fantinibakery.com>
References: <3F8ACBD2.CA1B8CBD@vitoni.de> <3F8AD02C.8080606@fantinibakery.com> <3F8AE51C.3F0A9451@vitoni.de> <3F8B039F.2070403@fantinibakery.com> <3F8B1491.57BCF640@vitoni.de> <3F8B34FD.9000802@fantinibakery.com> <3F8B38E9.6983E25A@vitoni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8B38E9.6983E25A@vitoni.de>
To: Victor <linux-raid@vitoni.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

my info:
mandrake 9.1
mdadm 1.2.0

 do you have  ARRAY or DEVICE entries in your /etc/mdadm.conf ?
 if so try commenting them out and run the mdadm command again.


 Did the GENTOO mdadm come with a  monitoring script for in /etc/init.d 
?  Mandrake's rpm did not. 
RedHats's mdadm rpm contains  /etc/init.d/mdmonitor  script which does a 
great job running mdadm --monitor.
I used RH's mdmonitor on the Mandrake computer. works great, with just 2 
lines in /etc/mdadm.conf.

 RedHat seems to have software raid implemented better than Mandrake.



Victor wrote:

>mdadm - v1.2.0 - 13 Mar 2003
>on Gentoo (something like v1.4 with lots of updates)
>
>
>  
>
>  
>

