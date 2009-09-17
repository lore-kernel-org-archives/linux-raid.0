From: "Rainer Fuegenstein" <rfu@kaneda.iguw.tuwien.ac.at>
Subject: Re: recommended 4port SATA controller ?
Date: Fri, 18 Sep 2009 01:48:16 +0200 (CEST)
Message-ID: <46495.81.217.58.120.1253231296.squirrel@kaneda.iguw.tuwien.ac.at>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at>
    <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
    <4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at>
    <20090917215240.GA418@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090917215240.GA418@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Anyway, you asked for four ports, but how about eight?  I'm
> surprised no one has mentioned this yet---I'd consider it a bit of a
> "classic": Supermicro AOC-SAT2-MV8.
>
>     http://www.newegg.com/Product/Product.aspx?Item=N82E16815121009

If it really works with PCI, this is my choice. which kernel module is
handling the card ?

> I can't speak to its power consumption; there are no heatsinks on
> the board, that should mean something.
the documentation even mentions 0.7A @ 5V that's one more reason to go for
this one.

thanks !


I don't know, but I would
> guess that the PCI bus wasn't designed to provide a lot of power
> anyway.
>
> Hope that helps!
> Matt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

