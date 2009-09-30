From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Slow network speeds between Linux RAID box and Windows PC
Date: Tue, 29 Sep 2009 23:40:12 -0600
Message-ID: <200909292340.12519.tfjellstrom@shaw.ca>
References: <3513de790909292020k79f6b83blf62e73aeb91d4681@mail.gmail.com> <3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3513de790909292022hbff20ben3d758602f12970c1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue September 29 2009, you wrote:
> I apologize that this question is not directly related to mdadm, but I
> thought some of the list might have experience in a mixed
> Linux/Windows environment.  I am running a mdadm RAID5 file server on
> a Ubuntu 8.04 Linux box on a gigabit LAN.  I am using a Highpoint 2680
> card at PCI-E 4x as the controller (I have also tried the motherboard
> SATA connectors directly).  I am running SAMBA on this box to share my
> RAID5 with my main Windows PC running Windows 7 64 bit (although I
> have gotten similar results with Vista also).
> My question is related to what I consider slow speeds when reading
> from or writing to the array from my Windows box.  I get anywhere from
> 20-30MB/s in either direction when transferring a single large file (3
> GB as an example).  I haven't done detailed benchmarking on the array,
> but spotchecks of file transfers from another drive on the same linux
> box are giving me speeds above 100MB/s for reads and writes.
> Does anyone have any suggestions for improving my speeds across the
> network?  I don't know if SAMBA is causing some kind of bottleneck or
> if Windows is not playing nice or if it's something with my network
> configuration, but I was hoping to get alot closer to saturating the
> gigabit connection.  Any help would be greatly appreciated.

I had rather sucky GbE stats till I tweaked a bunch of linux network settings. 
Things like the default buffer sizes and what not. Boosted the quite low 
30MB/s I was getting to over 90MB/s. Look up some guides to tweak each os's 
network settings, and you should beable to speed things up.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
