From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Spare disk could not sleep / standby
Date: Tue, 8 Mar 2005 07:24:46 +0100
Message-ID: <62b0912f050307222494fe17f@mail.gmail.com>
References: <422D327D.11718.F8DB3@localhost>
	 <200503080414.j284EG510309@www.watkins-home.com>
	 <16941.11443.107607.735855@cse.unsw.edu.au>
	 <62b0912f0503072120776e0b56@mail.gmail.com>
	 <16941.14813.465306.72004@cse.unsw.edu.au>
	 <62b0912f05030721465e84e4da@mail.gmail.com>
	 <16941.16439.595486.231598@cse.unsw.edu.au>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <16941.16439.595486.231598@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>> Is my perception of the situation correct?
> 
> No.  Writing the superblock does not cause the array to be marked
> active.
> If the array is idle, the individual drives will be idle.

Ok, thank you for the clarification.

>> Seems like a design flaw to me, but then again, I'm biased towards
>> hating this behaviour since I really like being able to put inactive
>> RAIDs to sleep..
> 
> Hmmm... maybe I misunderstood your problem.  I thought you were just
> talking about a spare not being idle when you thought it should be.
> Are you saying that your whole array is idle, but still seeing writes?
> That would have to be something non-md-specific I think.

No, the confusion is my bad.
That was the original problem posted by Peter Evertz, which you
provided a workaround for.

_I_ was just curious about the workings of MD in 2.6, since it sounded
a bit like it wasn't possible to put a RAID array to sleep.  I'm about
to upgrade a server to 2.6, which "needs" to spin down when idle.  Got
a bit worried for a moment there =).

Thanks again.
