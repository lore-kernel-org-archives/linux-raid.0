From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Disks out of sync
Date: Mon, 30 Sep 2002 19:47:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D988E47.2090300@hum.auc.dk>
References: <Pine.LNX.4.21.0209301407430.9633-100000@macaroni.penguin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Parsons wrote:
> Hi all
> 
> I have a 3 disk soft raid5 array. One disk has failed. Due to a
> faulty removable drive tray the other disks are out of sync. The data on
> the remaining disks should be identical.
> 
> Can someone please refresh my memory, on how to re-sync the disks. 

It's in the FHOWTO:

http://www.tldp.org/HOWTO/Software-RAID-HOWTO-6.html#ss6.1

Mark your failed disk as failed in /etc/raidtab and do a mkraid

-- 
Mads

