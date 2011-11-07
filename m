From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: Special drives for Linux Raid?
Date: Mon, 07 Nov 2011 08:49:44 -0500
Message-ID: <4EB7E1F8.7060803@meetinghouse.net>
References: <4EB7DD23.9090907@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB7DD23.9090907@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Danilo Godec wrote:
> Some manufacturers make 'special' versions of drives for RAID (WD RE4, 
> Seagate SE, ...). Apparently the main difference is in error handling, 
> where normal 'desktop' drives try hard to recover an error (up to 
> several minutes) while RAID drives give up quickly (few seconds) so 
> that the RAID controller can take over.
>
not so much "special" as "different"

the term to look for is "enterprise"

you've identified the key distinction:

- desktop drives assume that they have the only copy of your data, the 
on-board processor tries very hard to read and re-read until it returns 
your data ---- the result is that everything slows down

- if you have a raid array, you want a failing disk to give up and 
return, very quickly, so that the data can be read from a different drive

I learned this the hard way, when I had a server that just slowed way 
down to the point that it took 10 seconds or more to echo a keystroke.  
It took me a long time to figure out what was going on - and some rather 
painful false starts (trashed the o/s).

One important thing I discovered:  the md RAID driver does NOT consider 
a long time delay as a signal to fail a drive out of an array.  It's a 
really good idea to run mdstat and keep an eye on your drives.  If Raw 
Reed Error goes above 0, start paying attention.

Miles Fidelman



-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


