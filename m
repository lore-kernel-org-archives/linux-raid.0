From: TJ <systemloc@earthlink.net>
Subject: Re: Good news / bad news - The joys of RAID
Date: Thu, 2 Dec 2004 11:47:12 -0500
Message-ID: <200412021147.12410.systemloc@earthlink.net>
References: <Pine.LNX.4.44.0411201657570.19120-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0411201657570.19120-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> afaikt, the deathstar incident was actually bad firmware
> (didn't correctly flush data when hard powered off, resulting in
> blocks on disk with bogus ECC, which had to be considered bad from
> then on, even if the media was perfect.)

I do not think the deathstar incident was due to a firmware problem as you 
describe at all. I had a lot of these drives fail, and I read as much as I 
could find on the subject. The problem was most likely caused by the fact 
that these drives used IBM's new glass substrate technology. This substrate 
had heat expansion issues which caused the heads to misalign on tracks and 
eventually cross write over tracks, corrupting data. The classic "click of 
death" was the sound of the drive searching for a track repetitively. In some 
cases a format would allow the drive to be used again, in many cases it would 
not. It is my belief that formatting was inneffective at fixing the drive 
because the cross writing probably hit some of the low level data, which the 
drive cannot repair on a format.
