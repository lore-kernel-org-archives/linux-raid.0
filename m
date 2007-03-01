From: rabbit@rabbit.us (Peter Rabbitson)
Subject: swap on raid
Date: Thu, 1 Mar 2007 17:27:40 -0500
Message-ID: <20070301222739.GA4835@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I need to use a raid volume for swap, utilizing partitions from 4 
physical drives I have available. From my experience I have three 
options - raid5, raid10 with 2 offset chunks, and two raid 1 volumes 
that are swapon-ed with equal priority. However I have a hard time 
figuring out what to use as I am not really sure how can I detect the 
usage patterns of swap, left alone benchmark it. Has anyone done 
anything like this, or is there information on what kind of reads/writes 
the kernel performs when paging in and out?

Before you answer my question - yes, I am painfully aware of the 
paradigm "swap on raid is bad", and I know there are other ways to solve 
it, but my situation requires me to have swap. Several weeks ago a drive 
failed and took a full partition away bringing the system to its knees 
and causied massive data corruption. I am also aware that I can use a 
file that will reside alongside my other data, but fragmentation makes 
this approach inefficient. So I am looking into placing the swap 
directly on a raid voulme.


Thanks 

Peter

