From: "Billy Crook" <billycrook@gmail.com>
Subject: Re: non-degraded component replacement was Re: Distributed spares
Date: Tue, 14 Oct 2008 08:18:05 -0500
Message-ID: <a43edf1b0810140618n28b0f3e4lec5f2bb6e15c1626@mail.gmail.com>
References: <48F3C2A1.3080607@tmr.com>
	 <alpine.DEB.1.10.0810131810570.16807@p34.internal.lan>
	 <a43edf1b0810131530x36a69089la0d5d26a2228b796@mail.gmail.com>
	 <48F48A49.2000200@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48F48A49.2000200@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>, dean@arctic.org
List-Id: linux-raid.ids

On Tue, Oct 14, 2008 at 07:02, David Greaves <david@dgreaves.com> wrote:
> Billy Crook wrote:
>> It would be even nicer if there were a way to hot-transfer one
>> raid component to another without setting anything faulty.  I suppose
>> you could make all the components of the real array be single disk
>> raid1 arrays for that purpose.  Then you could have one extra disk set
>> aside for this sort of scrubbing, and never even be down one of your
>> parities.  I guess I should add that onto my todo list....
>
> IMHO This one should be high on the todo list. Especially if it's a
> pre-requisite for other improvements to resilience.

Here's the process as I thought it out.  I'm sure it can be improved upon:

Component C will be the current drive that one wishes to take out of service.
Component N will be the new drive that one wishes to put in service in
place of component C.

Redirect incoming writes from component C to component C AND N.
Check to make sure component N is same size or larger than C.
Create counter curBlock to store position of the drive copy,
(initialize counter at 0).
While curBlock < component C's block count:
 Copy block curBlock from component C to curBlock on component N.
   If copy fails, then try to construct that block from the other
disks using parity and apply that to component N.
 Increment curBlock.
Once the copy is complete, optionally verify by comparing both components.
Set curBlock to 0 again.
While curBlock < component C's block count:
 Compare curBlock on component C to curBlock on component N.
   If compare fails, then terminate with error and stop mirroring writes to N.
 Increment curBlock.
Redirect reads from component N only.
Stop writing to component C, and only write to N.
Present some notification that this process is done.

At all points during the process, redundancy should be as good as or
better than before the process.  The process can be aborted at any
time without disruption to the array.  This could be represented IMHO
with some different status designator character in /proc/mdstat like M
(for migrating), and the name for this capability, I'd call "Hot raid
component migration".  Just so long as people realise its an option
for replacing raid components more safely.  I bet the majority of the
code needed is already in the raid1 personality.  You could accomplish
the same thing by building your 'real' array ontop of single-disk
raid1 arrays, but oh that would be messy to look at!
