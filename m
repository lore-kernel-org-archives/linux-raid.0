From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid question
Date: Wed, 20 Aug 2003 16:31:18 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16195.5558.718161.146566@gargle.gargle.HOWL>
References: <3F405F90@webmail.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jshankar on Sunday August 17
To: jshankar <jshankar@CS.ColoState.EDU>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday August 17, jshankar@CS.ColoState.EDU wrote:
> Hello,
> 
> I have couple of questions regarding raid routine.
> 
> 1> When i do mkraid, is there any specific routines in md.c that is 
> responsible for adding and tracking the device. I have maintain the entries in 
> /etc/raidtab. When i copy a file into the raid device, is there any specific 
> routine that track  the  device to write the next block( raid 0
> case).

There is no concept of a "next block"
raid0 gets given a number of blocks to write (or read).  Each block
has an address.
raid0 does some simple arithmetic to decide which device, and which
block on that device, to use.
This code is in
   raid0.c(raid0_make_request).

> 
> 2> Also the routine that  keeps track the amount
> of buffer size that can be written to each particular device and the case when
> the writing to one disk fails.
> 

This questions doesn't really make sense to me.

> 
> 
> 3> Also i was  wondering whether the source code of raid tools are availaible 
> in
> linux directory.

google can probably find it for you.
I think there is a link somewhere like
  http://www.kernel.org/pub/linux/utils/raid

NeilBrown

> 
> It would be great if somebody  can throw some light.
> 
> Thanks in advance.
> 
> 
> -Jay
> 
> 
> 
> >===== Original Message From Neil Brown <neilb@cse.unsw.edu.au> =====
> >On Wednesday July 30, jshankar@CS.ColoState.EDU wrote:
> >> Hello ,
> >>
> >> I am Jayshankar, Masters student in Colorado State UNiversity.
> >>
> >> A small question on raid.
> >>
> >> Suppose i have got raid0 connected to disk1, disk2 , disk3 , disk4.
> >>
> >> The operating system writes a block of data to disk1 then to disk2, disk3,
> >> disk4. Do the I/O needs to be successful on disk1, for writing the next
> block
> >> of data on disk2, disk3, disk4. Or it checks the I/O is successful on
> disk1,
> >> after the block of data has been written to disk2,disk3,disk4.
> >>
> >>
> >> Looking forward for your reply.
> >>
> >> THanks in advance.
> >>
> >> -Jay
> >
> >Please send future questions to
> >  linux-raid@vger.kernel.org
> >rather than to me personally.
> >
> >All disk IO in Linux is asynchronous.
> >i.e. submitting a block schedules it for IO.  If you submit lots of
> >blocks they all get scheduled for IO.  This is true whether your are
> >accessing a single device or a raid array.
> >
> >So there is no check for success of one block before writing the
> >next.  quite often the blocks writen to the different drive will all
> >be written at one.
> >
> >NeilBrown
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
