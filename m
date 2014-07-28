From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: changing to fewer larger disks
Date: Mon, 28 Jul 2014 15:51:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1407281545030.7929@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

I just had a thought, now that we're seeing much larger drives becoming 
available, like 6TB-drives, it would be nice if it was possible to take an 
array consisting of 2TB-drives, replace a few of them with 6TB-drives 
(with want-replace) and then tell MD to restripe the entire array onto 
these fewer larger drives.

Concrete example:

10 bays, currently RAID6 in 9 disks + 1 spare, all disks 2TB ones.

If I took out the spare and replaced it with a 6TB drive and one by one, 
did want-replace so 5 of the drives were 6TB drives, I now potentially 
have the space to keep the same contents on 5 6TB drives intead of 9 2TB 
drives.

If I told mdadm to reduce the number of data drives to 5, would it then 
intelligently choose the 5 largest ones and keep the data area intact (or 
even grow it a little), or what would it do? If this is not the case, 
could this functionality needed be added to the feature request list, 
whereever that list might live?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
