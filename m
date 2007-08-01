From: David Greaves <david@dgreaves.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Wed, 01 Aug 2007 18:13:19 +0100
Message-ID: <46B0BF2F.3090603@dgreaves.com>
References: <312225.34192.qm@web54110.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <312225.34192.qm@web54110.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael <big_green_jelly_bean@yahoo.com>
Cc: Daniel Korstad <dan@korstad.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael wrote:
> I have removed the drives from my machine, the problem Im having is that I dont know the order (ports) they go back into the machine.
Does anyone know how to determine the order, or how to fix the drive array if 
the order is not correct?

If you are not attempting a (complex) repair then it won't matter.

Assuming you can identify the boot device and get the OS running then just do an 
'assemble' and md/mdadm will figure out the correct order.

You may however want to record the (new) order for future reference in case you 
need to do a complex repair.


David
PS Next time you have a new problem you may want to start a new thread.
