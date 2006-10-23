From: Neil Brown <neilb@suse.de>
Subject: Re: raid 5 read performance
Date: Mon, 23 Oct 2006 14:15:42 +1000
Message-ID: <17724.16878.840243.479385@cse.unsw.edu.au>
References: <5d96567b0605210210wc3925ek6161f427944f8b7@mail.gmail.com>
	<17520.12342.245437.75779@cse.unsw.edu.au>
	<Pine.LNX.4.64.0610210015390.23381@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Saturday October 21
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday October 21, raid@a2000.nu wrote:
> On Sun, 21 May 2006, Neil Brown wrote:
> 
> > Please read
> > 
> > http://www.spinics.net/lists/raid/msg11838.html
> > 
> > and ask if you have further questions.
> 
> Neil,
> 
> what is the current status on the slow read performance with 2.6 ?
> 

You mean by-passing the cache to avoid extra copy and synchronisation
overheads?
I have the patches.  I tried them once and couldn't measure any
speedup (I didn't try very hard) and put them aside think "I have to
look into this properly" and haven't got back to it yet.

Thanks for the reminder.  Hope to do some performance measurements
soon.  I'll make sure I include these patches when I do.

NeilBrown
