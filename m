From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: > 2TB ?
Date: Fri, 11 Feb 2005 10:32:30 +0100
Message-ID: <62b0912f0502110132630b3ae4@mail.gmail.com>
References: <09d601c50fb1$b9c9df10$020a0a0a@musicroom>
	 <l6vsd2-blf.ln1@news.it.uc3m.es>
Reply-To: Molle Bestefich <molle.bestefich@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l6vsd2-blf.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No email <null@hotmail.com> wrote:
>
> Forgive me as this is probably a silly question and one that has been
> answered many times, I have tried to search for the answers but have
> ended up more confused than when I started.  So thought maybe I could
> ask the community to put me out of my misery
>
> Is there a version of MD that can create larger than 2TB raid sets?

I have a couple of terabyte software RAID 1+0 arrays under Linux.
No size problems with MD as of yet.

But the filesystems is a different affair, and I think this is where
you should watch out.
Linux filesystems seems to stink real bad when they span multiple
terabytes, at least that's my personal experience.  I've tried both
ext3 and reiserfs.  Even simple operations such as deleting files
suddenly take on the order of 10-20 minutes.

I haven't got a ready explanation for why ext3 and reiser can't handle
TB sizes, but I'd definately advice you against a multi-TB setup using
Linux (at least until you find someone who has a working setup..)
