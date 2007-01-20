From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.19.2, cp 18gb_file 18gb_file.2 = OOM killer, 100% reproducible
Date: Sat, 20 Jan 2007 16:03:42 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0701201602570.4910@p34.internal.lan>
References: <Pine.LNX.4.64.0701201516450.3684@p34.internal.lan>
 <3aa654a40701201245s72b2f76hc70ddd94b70ba99c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3aa654a40701201245s72b2f76hc70ddd94b70ba99c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avuton Olrich <avuton@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 20 Jan 2007, Avuton Olrich wrote:

> On 1/20/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> > Perhaps its time to back to a stable (2.6.17.13 kernel)?
> >
> > Anyway, when I run a cp 18gb_file 18gb_file.2 on a dual raptor sw raid1
> > partition, the OOM killer goes into effect and kills almost all my
> > processes.
> >
> > Completely 100% reproducible.
> >
> > Does 2.6.19.2 have some of memory allocation bug as well?
> 
> I had been seeing something similar (also with 2.6.19.2), but it's not
> outputting anything to dmesg, so I was waiting for something to happen
> before I reported it. It's mostly the same thing, but I've only seen
> it happen when copying something large (2+ GB) over NFS. Interactivity
> completely goes away and lockups last 10-15 seconds a piece. Then
> realized I turned the swap off, so I turned it on and didn't lockup
> any longer.
> -- 
> avuton
> --
> Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
> 
> 

My swap is on, 2GB ram and 2GB of swap on this machine.  I can't go back 
to 2.6.17.13 as it does not recognize the NICs in my machine correctly and 
the Alsa Intel HD Audio driver has bugs etc, I guess I am stuck with 
2.6.19.2 :(

Justin.

