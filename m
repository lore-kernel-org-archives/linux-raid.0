From: rob <rob@fantinibakery.com>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Mon, 27 Oct 2003 22:32:27 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F9DE34B.5030701@fantinibakery.com>
References: <3F9DAD4C.3000002@verizon.net> <3F9DBA46.7020806@calixo.net> <200310280255.51504.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310280255.51504.maarten@vbvb.nl>
To: maarten van den Berg <maarten@vbvb.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I use rsync and spare inexpensive computers to backup our servers.

Our business requires 7x24 computer access with minimal downtime when 
the server fails.

I have 3 backup computers.

1st - next to the main computer.

2nd- at the other end of the building.

3-rd at my house. 

 hourly all our data files are rsynced to the 3 backup servers. This 
takes  1-3 min.

 also 2x  per hour  our main data files are synced.  this takes < 2 min.

 Rsync is a great program for backup as it sends just the parts of the 
file which changed.

 In addition we use dds-4 tape to backup 1x per day. the tape is taken 
offsite.

So use rsync over ethernet to backup to a spare computer or 2.





