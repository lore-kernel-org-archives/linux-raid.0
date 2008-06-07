From: "John Bridges" <john.bridges@gmail.com>
Subject: Re: Question on hotplug SATA controllers
Date: Fri, 6 Jun 2008 18:20:32 -0700
Message-ID: <fa3b69580806061820s1813adb6x637ed9461b86c672@mail.gmail.com>
References: <484963E0.4010009@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484963E0.4010009@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 6, 2008 at 9:20 AM, Peter Rabbitson <rabbit+list@rabbit.us> wrote:
> Apologies for yet another off-topic thread :)
>
> Since there has been some discussion about not-quite-server grade hardware,
> I would like to ask about your experience with SATA controllers that fully
> support hotplug. By fully support I mean I can pull a drive, have udev
> register it as missing, put it back in - have the device node re-appear in
> /dev. To date I am not aware of any consumer grade (i.e. can be found on
> newegg) controller/chipset which can actually do this. Does such a card
> exist?
>

What about the AOC-SAT2-MV8?
http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV8.cfm

It's the least expensive 8 port card I've found.

Have the drivers progressed far enough to support hotswap? It didn't
work last year when I tried it, but I see there have been updates
made.
