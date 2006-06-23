From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 15:30:24 +0200
Message-ID: <fd8d0180606230630x3f6b1ab7g444716cf8d5ab2c2@mail.gmail.com>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
	 <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com>
	 <449BE381.6070000@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449BE381.6070000@cjx.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Chris Allen <chris@cjx.com>
List-Id: linux-raid.ids

> Strange that whatever the filesystem you get equal numbers of people
> saying that
> they have never lost a single byte to those who have had horrible
> corruption and
> would never touch it again.
[...]

Loosing data is worse than loosing anything else. You can buy you
another hard drive, you can buy you another CPU, but you won't buy you
all the data you lost... And as far as I know, true life does not
implement the "Undo" button,
So, as a matter of facts, I started to think that choosing a FS is
much more a matter of personnal belief than any kind of scientific,
statistical, even empirical benchmarking. Something like a new kind of
religion...

For example, back in the reiser3.6's first steps in life, I
experienced a handfull of oopses, and fuzzy things that made my box
think it was running a Redmond stuff... So I neglected Reiser.
Then Reiser4 concepts came to my ear, several years after, and I
thought that, well, you know, Hans Reiser has great ideas and
promising theories, let's have a closer look at it.
So I came back testing reiser3.6. Which just worked flawlessly.
And you know what ? I never had time to play with Reiser4 yet.

So I finally chose XFS for all my more-than-2G partitions, with regard
to thread contents I started back to january : "Linux MD raid5 and
reiser4... Any experience ?".

Anyway, I'm shared between two points of view regarding the fs
experience in Linux
- maybe FS can not be generic, and cannot cover all usage scenarii.
Some are good for doing some stuff, some are better for some others...
And you'll have to chose with regard to your own usage forecasts.
- or maybe there's too much choice inthere : whenever a big problem
arises, it's easier to switch filesystems than to go bug hunting... At
least that's the way I reacted a couple of times. And because data
loss is such a sensible topic, when trust is broken, you just want to
change all stuff around, and start hating what you were found of a
minute ago...
