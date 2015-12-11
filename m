From: "John Stoffel" <john@stoffel.org>
Subject: Re: best base / worst case RAID 5,6 write speeds
Date: Fri, 11 Dec 2015 11:32:15 -0500
Message-ID: <22122.64143.522908.45940@quad.stoffel.home>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZURK+bZ=4czbGojzW815Du1ascr5vzAPtQBw4ZDGyq0MAQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Mark Knecht <markknecht@gmail.com>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Dallas" == Dallas Clement <dallas.a.clement@gmail.com> writes:

Dallas> Hi Mark.  I have three different controllers on this
Dallas> motherboard.  A Marvell 9485 controls 8 of the disks.  And an
Dallas> Intel Cougar Point controls the 4 remaining disks.

What type of PCIe slots are the controllers in?  And how fast are the
controllers/drives?  Are they SATA1/2/3 drives?  

>> If you're spinning in IO loops then it could be a driver issue.

Dallas> It sure is looking like that.  I will try to profile the
Dallas> kernel threads today and maybe use blktrace as Phil
Dallas> recommended to see what is going on there.

what kernel aer you running?

Dallas> This is pretty sad that 12 single threaded fio jobs can bring
Dallas> this system to its knees.

I think it might be better to lower the queue depth, you might be just
blowing out the controller caches...  hard to know.
