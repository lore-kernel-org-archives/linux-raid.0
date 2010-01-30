From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Sat, 30 Jan 2010 23:20:49 +0100
Message-ID: <4B64B0C1.1040503@texsoft.it>
References: <4B5F6C73.30707@texsoft.it> <20100127074138.GA9607@maude.comedia.it> <20100129214852.00e565c4@notabene> <4B647E0E.6050609@texsoft.it> <4B64A779.6070809@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B64A779.6070809@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> RAID-5 unfortunately is inherently insecure, here is why:
> If one drive gets kicked, MD starts recovering to a spare.
> At that point any single read error during the regeneration (that's a 
> scrub) will fail the array.
> This is a problem that cannot be overcome in theory.
Yes, I was just getting the same conclusion :-(
Suppose you have 2Tb mainstream disks, with a read error ratio of 1 
sector each 1E+14 bits = 1.25E+13 bytes.
It means that you likely get an error every 6.25 times you read the 
whole disk!
So in case of failure of a disk, you have 1 possibility over 6 to fail 
the array during recostruction.
Simply unacceptable!

I looked at specs of some enterprise disks, and the read error ratio for 
them is 1 sector each 1E+15 or each 1E+16. Better but still risky.
Ok.. I'll definitely move to raid-6.

Also raid-1 with less than 3 disks becomes useless the same way :-(
Idem for raid-10 ...wow

Well, these two threads on read errors came out as kinda instructive ... 
doh!!

Regards

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


