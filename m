From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: Joys of spare disks!
Date: Wed, 2 Mar 2005 04:50:35 +0100
Message-ID: <62b0912f050301195062c3afbe@mail.gmail.com>
References: <cvv9ai$svg$1@sea.gmane.org> <d03987$nif$1@sea.gmane.org>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <d03987$nif$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> I envisage something like:
> 
> md attempts read
> one disk/partition fails with a bad block
> md re-calculates correct data from other disks
> md writes correct data to "bad" disk
>   - disk will re-locate the bad block

Probably not that simple, since some times multiple blocks will go
bad, and you wouldn't want the entire system to come to a screeching
halt whenever that happens.

A more consistent and risk-free way of doing it would probably be to
do the above partial resync in a background thread or so?..
