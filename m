From: Warren Young <warren@etr-usa.com>
Subject: Re: Fast RAID rebuild?
Date: Thu, 24 Jul 2003 15:38:12 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F2051C4.8020001@etr-usa.com>
References: <Pine.LNX.4.53.0307221333120.21063@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0307221333120.21063@duplo.agenda.si>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

danci@agenda.si wrote:
> 
> Is there a way to quickly add the disk back to array without resyncing
> - something like 'mdadm --unfail'? :)

md is right not to trust the state of the replaced disk.  Just in order 
to get to the mdadm point, you have to boot up, which means files have 
changed on the live disks relative to the one that was temporarily 
missing.  You'd risk massive corruption by forcing it to accept the new 
disk without rebuilding the array.

You maybe could get away with this in a hardware RAID system because you 
can administer the array before the OS comes up.  None of the RAID cards 
I've ever played with allow this, though.

The real solution to your problem is to put all the disks on the same 
kind of controller.  A 4-port 3Ware card, for instance.  Then all disks 
come up together or none of them do.  You can still use Linux soft RAID 
with most hardware RAID cards, if you must.  Or, if you want to cheap 
out, get a 2-port Promise IDE card and put the three disks on it.

