From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: My MD is too big to resize ext4.
Date: Sat, 8 Jul 2017 09:40:42 +0200
Message-ID: <9dee7eb4-795e-a30e-8cd6-d38d0ad9891b@thelounge.net>
References: <6c827d07-19d8-017b-ca95-5e6f84b7821a@gmail.com>
 <02786811-5d00-af90-adfd-82ae3f9f0781@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <02786811-5d00-af90-adfd-82ae3f9f0781@fnarfbargle.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 08.07.2017 um 09:34 schrieb Brad Campbell:
> Alternatively, find a machine with 6 slots, build a RAID6 from the 
> drives you already have. Copy the data across, re-format the new array 
> and copy the data back. A bit of double handling, but no loss of 
> redundancy or integrity. Run md5 or something over all the files to make 
> sure it's all good, or use rsync with the "always checksum" option, 
> although this is slow

--checksum
If the file size and time match, it will do a checksum at both ends to 
see if the files are really identical

that won't do much when the target is empty
