From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 08:53:12 -0400
Message-ID: <hb4hjp$cg8$1@ger.gmane.org>
References: <hb1udb$6t1$1@ger.gmane.org> <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com> <hb2470$rol$1@ger.gmane.org> <70ed7c3e0910130810r58ab391id2fbfdff6200dcd8@mail.gmail.com> <hb3qpa$6ep$1@ger.gmane.org> <70ed7c3e0910132340q1c4acdfbxa6938261088acca3@mail.gmail.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Majed B. wrote:

> I see.
> 
> Well, whether MD is smart enough to rearrange a queue when the arrays
> are sharing disks or not, it still means that you can't run your
> processes in parallel.

Does that means that different processes (treads) can't request reads on 
different places on the disk concurrently?

I am sorry, but it seems that we are speaking different languages.

-- 
Antonio Perez

