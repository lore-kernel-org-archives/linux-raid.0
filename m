From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: async writes in raid1
Date: Tue, 15 Apr 2003 09:50:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E9C0E43.2D4DBB3@SteelEye.com>
References: <200304141731_MC3-1-3462-2343@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: "ptb@it.uc3m.es" <ptb@it.uc3m.es>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chuck Ebbert wrote:
> 
> ptb wrote:
> 
> > I've done a few million async writes and haven't died yet. Of course I
> > don't know if this procedure works always.
> 
>  What happens if the system crashes before all the writes complete?

It depends which system crashes...

Peter's current code does not handle the primary server crashing at all,
since there is no disk backing of the bitmap. If the network fails or
the secondary fails, however, this can be recovered from without data
loss.

--
Paul
