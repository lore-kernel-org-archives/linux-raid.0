From: Nathan Lewis <nathapl@cs.okstate.edu>
Subject: Adding Reed-Solomon Personality to MD, need help/advice
Date: Sat, 31 Jan 2004 00:59:25 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As part of my Master's thesis, I am working on adding a Reed-Solomon 
personality to the existing linux RAID structure and I would like some 
assistance.  I'll try to keep this as brief as possible, but I apologize if 
it gets long-winded.

So far, I've managed to add and register a personality with md, which 
involved a few minor changes to md.c and related header files, a few 
changes to mdadm to allow me to access things from userland.  I've 
discovered the 9 functions I need to implement (make_request, run, stop, 
etc), and managed to "successfully" create an md device using only stub 
functions.  So far so good.  Just for reference, I'm using kernel 2.4.22.

However, I can't really find concise documentation on exactly what those 9 
functions are supposed to do, and under what restrictions they must do them 
in.  I've been studying Rubini and Corbet's _Linux Device Drivers_ book, 
which goes into great detail on the responsibilities of a block device 
driver, and even covers the make_request function.  For now, that's what 
I'm focusing on anyway.

Anyway, here's my first real question:  the buffer_head bh passed into 
make_request obviously contains a request for that particular 
device.  However, this buffer_head could be the head of a linked list, with 
the next element located at b_reqnext.  However, all of the code I can find 
that uses make_request ignores bh->b_reqnext.  Is it guaranteed to be the 
only request when bypassing __make_request?  Also, the request_queue_t q is 
also ignored.  I assume this is there for use by __make_request (since it 
isn't even passed to <personality>_make_request).

Second question:  Since <personality>_make_request doesn't alter the 
request_queue_t q, it need not worry about the io_request_lock that is 
stressed in the Rubini book, correct?  I think I only have to worry about 
locks for any internal structures/buffers I use/create.

Third question:  The raid5 thread is registered with the md 
driver.  Besides the code in raid5.c, what else can wake up this 
thread?  Anything?

That's probably enough for now.  I'm sure I'll have more questions down the 
line, but I need a thorough understanding of what is there before I can add 
anything to it.

Thanks,
--Nathan Lewis

nathapl@cs.okstate.edu

