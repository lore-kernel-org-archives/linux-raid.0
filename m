From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 15:24:52 -0600
Message-ID: <CAE9DZUTMnwpUX1e95c_i04uWREHd+aR8P2yCE_W-WmEbL6YRkw@mail.gmail.com>
References: <CAE9DZUR=uSzYfdqFkVFdyXx+iKb1SeXxo5eX7M_nTw-fnWBwNA@mail.gmail.com>
	<5669DB3B.30101@turmel.org>
	<CAE9DZUSNkLxaKH8MtggW+5_uo38CHRTcscvh7Kk-VTb_zWPQ4g@mail.gmail.com>
	<CAK2H+ednN7dCGzcOt8TxgNdhdDA1mN6Xr5P8vQ+Y=-uRoxRksw@mail.gmail.com>
	<CAE9DZUR1Nka=5mAB2WQHeFkinO0CzuH_GT1gRiVsuREQfgdGcQ@mail.gmail.com>
	<CAK2H+efF2dM1BsM7kzfTxMdQEHvbWRaVe7zJLTGcPZzafn2M6A@mail.gmail.com>
	<CAE9DZUQ+LOFWNQ2MpKoSx8j8RHVqkL15PO+jVjs7EkCQykG6VA@mail.gmail.com>
	<CAE9DZUQo4CojhuVkQ6y=gTEWG5qUkeu57wcZsqbXZtGD_V5JCQ@mail.gmail.com>
	<CAK2H+ec-zMbhxoFyHXLkdM-z-9cYYzNbPFhn19XjTHqrOMDZKQ@mail.gmail.com>
	<CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
	<22122.64143.522908.45940@quad.stoffel.home>
	<CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
	<22123.9525.433754.283927@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22123.9525.433754.283927@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 11, 2015 at 1:34 PM, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>
> Dallas> On Fri, Dec 11, 2015 at 10:32 AM, John Stoffel <john@stoffel.org> wrote:
>>>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>>>
> Dallas> Hi Mark.  I have three different controllers on this
> Dallas> motherboard.  A Marvell 9485 controls 8 of the disks.  And an
> Dallas> Intel Cougar Point controls the 4 remaining disks.
>>>
>>> What type of PCIe slots are the controllers in?  And how fast are the
>>> controllers/drives?  Are they SATA1/2/3 drives?
>>>
>>>>> If you're spinning in IO loops then it could be a driver issue.
>>>
> Dallas> It sure is looking like that.  I will try to profile the
> Dallas> kernel threads today and maybe use blktrace as Phil
> Dallas> recommended to see what is going on there.
>>>
>>> what kernel aer you running?
>>>
> Dallas> This is pretty sad that 12 single threaded fio jobs can bring
> Dallas> this system to its knees.
>>>
>>> I think it might be better to lower the queue depth, you might be just
>>> blowing out the controller caches...  hard to know.
>
> Dallas> Hi John.
>
>>> What type of PCIe slots are the controllers in?  And how fast are the
>>> controllers/drives?  Are they SATA1/2/3 drives?
>
> Dallas> The MV 9485 controller is attached to an Intel Sandy Bridge
> Dallas> via PCIe GEN2 x 8.  This one controls 8 of the disks.  The
> Dallas> Intel Cougar Point is connected to the Intel Sandy Bridge via
> Dallas> DMI bus.
>
> So that should all be nice and fast.
>
> Dallas> All of the drives are SATA III, however I do have two of the
> Dallas> drives connected to SATA II ports on the Cougar Point.  These
> Dallas> two drives used to be connected to SATA III ports on a MV
> Dallas> 9125/9120 controller.  But it had truly horrible write
> Dallas> performance.  Moving to the SATA II ports on the Cougar Point
> Dallas> boosted the performance close to the same as the other drives.
> Dallas> The remaining 10 drives are all connected to SATA III ports.
>
>>> what kernel aer you running?
>
> Dallas> Right now, I'm using 3.10.69.  But I have tried the 4.2 kernel
> Dallas> in Fedora 23 with similar results.
>
> Hmm... maybe if your feeling adventerous you could try v4.4-rc4 and
> see how it works.  You don't want anything between 4.2.6 and that
> because of problems with blk req management.  I'm hazy on the details.
>
>>> I think it might be better to lower the queue depth, you might be just
>>> blowing out the controller caches...  hard to know.
>
> Dallas> Good idea.  I'll trying lowering to see what effect.
>
> It might also make sense to try your tests starting with just 1 disk,
> and then adding one more disk, re-running the tests, then another
> disk, re-running the tests, etc.
>
> Try with one on the MV, then one on the Cougar, then one on MV and one
> on Cougar, etc.
>
> Try to see if you can spot where the performance falls off the cliff.
>
> Also, which disk scheduler are you using?  Instead of CFQ, you might
> try deadline instead.
>
> As you can see, there's a TON of knobs to twiddle with, it's not a
> simple thing to do at times.
>
> John

> It might also make sense to try your tests starting with just 1 disk,
> and then adding one more disk, re-running the tests, then another
> disk, re-running the tests, etc

> Try to see if you can spot where the performance falls off the cliff.

Okay, did this.  Interestingly, things did not fall of the cliff until
adding in the 12th disk.  I started adding disks one at a time
beginning with the Cougar Point.  The %iowait jumped up right away
with this guy also.

> Also, which disk scheduler are you using?  Instead of CFQ, you might
> try deadline instead.

I'm using deadline.  I have definitely observed better performance
with this vs cfq.

At this point I think I need to probably use a tool like blktrace to
get more visibility than what I have with ps and iostat.
