From: bdameron@pivotlink.com
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 17:14:15 -0700
Message-ID: <1119485655.42b9fed75fc87@mail.pivotlink.com>
References: <5d96567b05061804477325d743@mail.gmail.com>  <200506221316.33178.hjm@tacgi.com>  <1119474566.11039.12.camel@dhcpc226.office.pivotlink.com>  <200506221443.28613.hjm@tacgi.com> <1119477636.5501.161.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119477636.5501.161.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Ming Zhang <mingz@ele.uri.edu>:

> will this 24 port card itself will be a bottleneck?
> 
> ming

Since the card is PCI-X the only bottleneck on it might be the Processor since 
it is shared with all 24 ports. But I do not know for sure without testing it. 
I personally am going to stick with the new 16 port version. Which is a PCI-
Express card and has twice the CPU power. Since there are so many spindles it 
should be pretty darn fast. And remember that even tho the drives are 150MBps 
they realistically only do about 25-30MBps. 

Brad Dameron
SeaTab Software
www.seatab.com 
