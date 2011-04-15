From: Simon McNair <simon@mcnair.co.uk>
Subject: single threaded parity calculation ?
Date: Fri, 15 Apr 2011 20:18:48 +0100
Message-ID: <4DA89A18.5010002@mcnair.co.uk>
Reply-To: simon@mcnair.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: philip@turmel.org
List-Id: linux-raid.ids

Hi all,
I'm under the impression that the read speed of my 10x1TB RAID5 array is 
limited by the 'single-threaded parity calculation' ? (I'm quoting Phil 
Turmel on that and other linux-raid messages I've read seem to confirm 
that terminology)  I'm running an i7 920 with irqbalance but if 
something is single threaded or single CPU bound I'm wondering what I 
can do to alleviate it.

iostat reports 83MB/s for each disk, running up to 830MB/s for all 10 
disks, but the max read speed of the array is approx 256MB/s.

Would it be better to have 5 (or more) partitions on each disk, create 
5xraid5 arrays (each of which would in theory have a separate thread) 
and then create a linear array over the top of them to join them together ?

yes...I know this is way overthinking and also a potentially dangerous 
to recreate, but I'm curious what the opinions are.  I think I'll 
probably just end up buying another 1TB drive and making it an 11 disk 
RAID6 instead.  I want maximum space, maximum speed and maximum 
redundancy ;-).

TIA :-)

Simon


