From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: md faster than h/w?
Date: Sat, 14 Jan 2006 09:19:41 +0800
Message-ID: <43C851AD.80006@fastmail.co.uk>
References: <dq7jii$n1c$1@sea.gmane.org> <20060113144640.GA10566@lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060113144640.GA10566@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@lug.udel.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift wrote:
> On Fri, Jan 13, 2006 at 03:06:54PM +0800, Max Waterman wrote:
>> One further strangeness is that our best results have been while using a 
>> uni-processor kernel - 2.6.8. We would prefer it if our best results 
>> were with the most recent kernel we have, which is 2.6.15, but no.
> 
> Sounds like this is probably a bug.  If you have some time to play
> around with it, I'd try kernels in between and find out exactly where
> the regression happened.  The bug will probably be cleaned up quickly
> and performance will be back where it should be.
> 
>> So, any advice on how to obtain best performance (mainly web and mail 
>> server stuff)?
>> Is 180MB/s-200MB/s a reasonable number for this h/w?
>> What numbers do other people see on their raid0 h/w?
>> Any other advice/comments?
> 
> My employer usues the 1850 more than the 2850, though we do have a few
> in production.  My feeling is that 180-200MB/sec is really excellent
> throughput.
> 
> We're comparing apples to oranges, but it'll at least give you an
> idea.  The Dell 1850s are sortof our highest class of machine that we
> commonly deploy.    We have a Supermicro chassis that's exactly like
> the 1850 but SATA instead of SCSI.  On the low-end, we have various P4
> Prescott chassis.
> 
> Just yesterday I was testing disk performance on a low-end box.  SATA
> on a 3Ware controller, RAID1.  I was quite pleased to be getting
> 70-80MB/sec.
> 
> So my feeling is that your numbers are fairly close to where they
> should be.  Faster procs, SCSI, and a better RAID card.  However, I'd
> also try RAID1 if you're mostly interested in read speed.  Remember
> that RAID1 lets you balance reads across disks, whereas RAID0 will
> require each disk in the array to retrieve the data.
> 

OK, this sounds good.

I still wonder where all the theoretical numbers went though.

The scsi channel should be able to handle 320MB/s, and we should have 
enough disks to push that (each disk is 147-320MB/s and we have 4 of 
them) - theoretically.

Why does the bandwidth seem to plateau with two disks - adding more into 
the raid0 doesn't seem to improve performance at all?

Why do I get better numbers using the file for the while device (is 
there a better name for it), rather than for a partition (ie /dev/sdb is 
faster than /dev/sdb1 - by a lot)?

Can you explain why raid1 would be faster than raid0? I don't see why 
that would be...

Things I have to try from your email so far are :

1) raid1 - s/w and h/w (we don't care much about capacity, so it's ok)
2) raid0 - h/w, with bonnie++ using no partition table
3) kernels in between 2.6.8 and 2.6.15

Max.
