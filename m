From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Hot swap on IDE
Date: Sat, 7 Dec 2002 14:48:03 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200212071448.03116.roy@karlsbakk.net>
References: <Pine.LNX.4.44.0212060830030.24068-100000@duplo.agenda.si> <037201c29d5a$1d4a6ef0$6a01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <037201c29d5a$1d4a6ef0$6a01a8c0@bmoon>
To: bmoon <bo@anthologysolutions.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

you don't want more than one disk per channel. it fscks up the performance big 
time. I'm aware of that 3ware's controllers are supposed to support hot swap, 
but they do not support more than one disk per channel. But then - their 
controllers have 4, 8 and 12 ports, so you don't need two drives per channel 
anyway

On Friday 06 December 2002 20:03, bmoon wrote:
> Hello,
>
> I want to find that anyone made a successful work for the HOT-SWAP
> on the IDE master/slave.
>
> Ther are many systems that use the IDE for RAID. However, I heard most of
> them
> use the MASTER.
>
> Is it really impossible to make use of both master and slave?
> I mean "Are there any sucess story to use the slave?".
>
> Thanks in advance,
>
> Bo
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Roy Sigurd Karlsbakk, Datavaktmester
ProntoTV AS - http://www.pronto.tv/
Tel: +47 9801 3356

Computers are like air conditioners.
They stop working when you open Windows.

