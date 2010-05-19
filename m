From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: mdadm: failed devices become spares!
Date: Wed, 19 May 2010 12:56:41 -0700
Message-ID: <AANLkTil4IPwCQejn6qU3_bRHALsxDVriH2edRcv6AyDm@mail.gmail.com>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com>
	 <201005172010.36157.pierre@vigneras.name>
	 <20100518113016.1981a08c@notabene.brown>
	 <20100518120637.24d875c9@notabene.brown>
	 <4BF313CC.9030401@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF313CC.9030401@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 18, 2010 at 3:25 PM, MRK <mrk@shiftmail.org> wrote:

> - USB is not good for RAID imho.

I  can second that. At one time I had a USB backup drive that was
configured as half a RAID 1 set. This was so that the drive could
immediately be used in the event of a massive failure of the file
server.

Pulling this USB drive before stopping the RAID device caused the
machine to become unresponsive. I think it was trying to do some kind
of I/O, all I know was that a hard boot was the only way I could get
the machine out of that condition.

Simon
