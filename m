From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: 3ware raid question
Date: Wed, 3 Aug 2005 10:26:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0508031025490.22417@router.windsormachine.com>
References: <5d96567b0508020352252af125@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0508020352252af125@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Aug 2005, Raz Ben-Jehuda(caro) wrote:

> i have encountered a weired feature of 3ware raid.
> When i try to put inside an existing raid a disk which
> belonged to a different 3ware raid if fail.
> Any idea anyone ?

It's a feature on the 9500S's.  You have to unlock the drive to be able to 
use it in another machine.  Protects you from accidentally wiping out a 
raid volume disk.

Mike
