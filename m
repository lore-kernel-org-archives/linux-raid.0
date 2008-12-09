From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Data integrity and RAID
Date: Tue, 9 Dec 2008 09:06:48 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812090905290.29505@p34.internal.lan>
References: <20841008.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20841008.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: "peter.stevens" <Peter.Stevens@gtech.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 9 Dec 2008, peter.stevens wrote:

>
> I'm looking for a software solution to help replace my existing raid hardware
> setup. The hardware mimics RAID-1 (in that it has 3 mirrors), except for the
> fact that on read all 3 mirrors are compared and possibly error corrected
> before data is returned. I don't neccessarily need a RAID-1 solution, it
> just seems closer to what I already have and also that it also can recover
> from 2 simulateous disk failures.
>
> So far I've played with a software RAID-1 array of USB flash drives. My
> issue is that software RAID-1 does not check for or recover from data
> corruption unless a read or write to disk actually fails. Integrity is a
> major concern for me, I need to know that all data going to and from disk is
> correct at all times.
>
> All advice and comments are welcomed.
Well USB flash isn't a traditional disk that remaps bad sectors etc.. 
AFAIK md/raid will try and correct read-errors, but for write errors you 
have to trust the disks to do this for you, otherwise the bad disk will be 
kicked out of the array.  If you need the bad write to be re-mapped 
elsewhere in the array you need a hw raid controller, 3ware, etc..

Justin.
