From: "John Madden" <jmadden@ivytech.edu>
Subject: Re: raid0 low performance
Date: Fri, 1 Jul 2005 07:54:45 -0500 (EST)
Message-ID: <49052.10.0.15.208.1120222485.squirrel@postal2>
References: <1120184148.5521.21.camel@localhost.localdomain>
    <42C4AA31.8040307@dtbb.net>
    <50513.168.91.5.7.1120186660.squirrel@localhost>
    <1120221664.5507.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120221664.5507.25.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
Cc: Tyler <pml@dtbb.net>, Linux RAID <linux-raid@vger.kernel.org>, Ming Zhang <mingz@ele.uri.edu>
List-Id: linux-raid.ids

> which one? i can not find. :P could u tell me? thx

lspci -vv

> but my friend run same code on a 3ware 4 disk raid0 and get 140MB
> easily.
>
> similar box, P4 2.8G 1G ram. supermicro board.

Then I agree with the other reply -- suspect that Marvel controller or its driver
is at fault.  Can you borrow your friend's controller? :)

John





-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

