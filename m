From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Rewrite md raid1 member
Date: Thu, 18 Aug 2016 11:27:55 +0800
Message-ID: <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com>
References: <20160818030451.GA17225@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160818030451.GA17225@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/08/16 11:04, Chris Dunlop wrote:
> G'day all,
>
> What options are there to safely rewrite a disk that's part of a live MD
> raid1?
>
> Specifically, I have smartctl reporting a Current_Pending_Sector of 360 on a
> member of a raid1 set.
>
> A 'check' of the raid comes up clean. I'd like to see if I can clear the
> pending sector count by rewriting the sectors. Whilst rewriting just those
> sectors would be ideal, I don't know which they are, so it looks like a
> whole disk write is the way to go.
>

A smartctl -t long on the drive will error out at the first problematic 
sector and put that LBA in the SMART log, so there's a start.

Another way to determine it is run dd from the drive, and it will abort 
on the first error telling you how many records it managed to copy. With 
the default bs of 512, that gives you a sector number.

> Or is this 'dd' stuff just nuts, a case of "well that's a novel way of
> trashing your data..." and/or "you're welcome to try, but you get to keep
> all the pieces and don't come crying to us for help!"?

Pretty much. If a RAID check is not touching them, then they are likely 
in the vacant area around the superblock. Nothing touches that, and 
playing with it can lead to tears if you misfire and hit the superblock 
or the data.

If the superblock is ok, and the errors are outside of the data area 
I've taken a drive out of the array, used dd_rescue to clone the area of 
the drive in question and then written that back to the disk and 
re-added to the array. That just re-writes the good data and with zeros 
where the bad sectors were.

That is a horrible, horrible procedure that I did on an array I use for 
testing and has no valuable data on. I would not recommend it if you 
care about your array or data.

Brad
