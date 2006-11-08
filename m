From: dean gaudet <dean@arctic.org>
Subject: Re: RAID5 array showing as degraded after motherboard replacement
Date: Tue, 7 Nov 2006 23:52:12 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611072350450.11298@twinlark.arctic.org>
References: <ef2613f30611050858m562386a0m7966667f803f35fc@mail.gmail.com>
 <Pine.LNX.4.64.0611051247550.13706@twinlark.arctic.org>
 <ef2613f30611051607t24fdcec0qe6f37227e4118b73@mail.gmail.com>
 <Pine.LNX.4.64.0611060028120.20361@twinlark.arctic.org>
 <ef2613f30611061618n185978daqc8e4a07368b6baec@mail.gmail.com>
 <ef2613f30611071715q2a6776eaya219349d667b43b1@mail.gmail.com>
 <ef2613f30611071716u1c5b8fcy373d1d632acddd17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ef2613f30611071716u1c5b8fcy373d1d632acddd17@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Lee <james.lee@cantab.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 8 Nov 2006, James Lee wrote:

> > However I'm still seeing the error messages in my dmesg (the ones I
> > posted earlier), and they suggest that there is some kind of hardware
> > fault (based on a quick Google of the error codes).  So I'm a little
> > confused.

the fact that the error is in a geometry command really makes me wonder...

did you compare the number of blocks on the device vs. what seems to be 
available when it's on the weird raid card?

-dean
