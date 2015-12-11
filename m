From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 10:47:32 -0600
Message-ID: <CAE9DZUQ=QynBKYJvq2JSnMaACKNpm+5yrhz+5x9Tx6_TK78mCg@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22122.64143.522908.45940@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Dec 11, 2015 at 10:32 AM, John Stoffel <john@stoffel.org> wrote:
>>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:
>
> Dallas> Hi Mark.  I have three different controllers on this
> Dallas> motherboard.  A Marvell 9485 controls 8 of the disks.  And an
> Dallas> Intel Cougar Point controls the 4 remaining disks.
>
> What type of PCIe slots are the controllers in?  And how fast are the
> controllers/drives?  Are they SATA1/2/3 drives?
>
>>> If you're spinning in IO loops then it could be a driver issue.
>
> Dallas> It sure is looking like that.  I will try to profile the
> Dallas> kernel threads today and maybe use blktrace as Phil
> Dallas> recommended to see what is going on there.
>
> what kernel aer you running?
>
> Dallas> This is pretty sad that 12 single threaded fio jobs can bring
> Dallas> this system to its knees.
>
> I think it might be better to lower the queue depth, you might be just
> blowing out the controller caches...  hard to know.

Hi John.

> What type of PCIe slots are the controllers in?  And how fast are the
> controllers/drives?  Are they SATA1/2/3 drives?

The  MV 9485 controller is attached to an Intel Sandy Bridge via PCIe
GEN2 x 8.  This one controls 8 of the disks.
The Intel Cougar Point is connected to the Intel Sandy Bridge via DMI bus.

All of the drives are SATA III, however I do have two of the drives
connected to SATA II ports on the Cougar Point.  These two drives used
to be connected to SATA III ports on a MV 9125/9120 controller.  But
it had truly horrible write performance.  Moving to the SATA II ports
on the Cougar Point boosted the performance close to the same as the
other drives.  The remaining 10 drives are all connected to SATA III
ports.

> what kernel aer you running?

Right now, I'm using 3.10.69.  But I have tried the 4.2 kernel in
Fedora 23 with similar results.

> I think it might be better to lower the queue depth, you might be just
> blowing out the controller caches...  hard to know.

Good idea.  I'll trying lowering to see what effect.
