From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: replace disk in raid5 without linux noticing?
Date: Sat, 22 Apr 2006 14:48:23 -0300
Message-ID: <17482.27751.358345.185741@fisica.ufpr.br>
References: <200604191631.04305.Dexter.Filmore@gmx.de>
	<e3edb0fa0604190931i1160d94eo829ba17943b0c5eb@mail.gmail.com>
	<200604212023.30855.Dexter.Filmore@gmx.de>
	<17481.23502.962814.840550@fisica.ufpr.br>
	<20060422110816.A22573@cons.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060422110816.A22573@cons.org>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Cracauer <cracauer@cons.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin Cracauer (cracauer@cons.org) wrote on 22 April 2006 11:08:
 >> stop the array
 >> dd warning disk => new one
 >> remove warning disk
 >> assemble the array again with the new disk
 >> 
 >> The inconvenience is that you don't have the array during the copy.
 >
 >Stopping the array and restarting it as readonly will give you access
 >to the data while that copy is in progress.

Yes but then you could just switch it to read-only without stopping.
