From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10 performance question
Date: Tue, 25 Dec 2007 21:34:52 +0000
Message-ID: <18289.30588.549513.84222@base.ty.sabi.co.UK>
References: <cccedfc60712230626t2db70cfcl5b0b49390cd6e609@mail.gmail.com>
	<18289.21791.151719.625145@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18289.21791.151719.625145@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Tue, 25 Dec 2007 19:08:15 +0000,
>>> pg_lxra@lxra.for.sabi.co.UK (Peter Grandi) said:

[ ... ]

>> It's the raid10,f2 *read* performance in degraded mode that is
>> strange - I get almost exactly 50% of the non-degraded mode
>> read performance. Why is that?

> [ ... ] the mirror blocks have to be read from the inner
> cylinders of the next disk, which are usually a lot slower
> than the outer ones. [ ... ]

Just to be complete there is of course the other issue that
affect sustained writes too, which is extra seeks. If disk B
fails the situation becomes:

    DISK
   A X C D

   1 X 3 4
   . . . .
   . . . .
   . . . .
   -------
   4 X 2 3       
   . . . .
   . . . .
   . . . .

Not only must block 2 be read from an inner cylinder, but to
read block 3 there must be a seek to an outer cylinder on the
same disk. Which is the same well known issue when doing
sustained writes with RAID10 'f2'.
