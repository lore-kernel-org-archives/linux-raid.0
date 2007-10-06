From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: raid5 growing question
Date: Sat, 06 Oct 2007 12:46:17 +1000
Message-ID: <4706F6F9.6080601@eyal.emu.id.au>
References: <20071005193159.GA8707@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071005193159.GA8707@csy.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Shane <shane@cm.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shane,

Please take the following with some suspicion.

I used raidreconf to add drives to an array, so I assume
the grow functionality can at least do the same.

I wonder: if you have less than 1TB of data then you can:
1 fail one 320GB disk (array now degraded!)
2 use the port to install 1x1TB as a degraded 2-disk RAID5
3 copy all the data across
4 remove the 5x320GB
5 install the other 2x1TB
	may need to resync the 2x before growing to 3x?
6 grow to 3x1TB RAID5

If you *do* have a spare port then in step 2 you can create
a degraded 3x1TB and step 6 is a simple resync when you add
the missing third disk. You can copy the full 1.6TB across
in this case.

Naturally, all this "degraded" means there is a real risk to
your data for a few hours, but you knew that.

However, when I do not have ports to play with I take the
slow solution and create the new RAID externally (using USB
or another computer over a net - there is always another
computer around for this job).

Good luck.

Eyal

Shane wrote:
> Hello all,
> 
> I have a raid5 softraid array using 6x320GB SATA drives.  I
> would like to reconfigure it to be 3x1tb SATA.  Is there a
> way to do this using the grow feature of mdadm.  IE by
> swapping 3 of the 320GB drives out for the 3 1TB drives
> allowing the resyncs to occur between swapping and then
> somehow tell mdadm to take the remaining three 320GB drives
> out of the array or would I need to just create a new array
> somehow, copy the data over and just shut the first array
> right down?
> 
> Thanks,
> Shane

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
