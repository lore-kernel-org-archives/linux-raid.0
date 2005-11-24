From: ross@jose.lug.udel.edu (Ross Vandegrift)
Subject: Re: mdadm 2.1: command line option parsing bug?
Date: Thu, 24 Nov 2005 02:31:51 -0500
Message-ID: <20051124073150.GA27418@jose.lug.udel.edu>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au> <62b0912f0511220741v4a926cc4w9bb18e72ad457ff5@mail.gmail.com> <17285.20141.12518.264787@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17285.20141.12518.264787@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Molle Bestefich <molle.bestefich@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 24, 2005 at 04:25:01PM +1100, Neil Brown wrote:
> Can you say anything more about the sort of mistakes you find yourself
> making.  That might help either improve the help pages or the error
> messages (revamping all the diagnostic messages to make the more
> helpful is slowly climbing to the top of my todo list).

I've been using mdadm from the very beginning, but the one thing I
still don't have a great handle on is the difference between querying
devices vs. arrays, and when to query what to find out what I want to
know.

Partly, I'm not familiar with it because it's not like I run mdadm
everyday.  It's the kind of thing that's run once, configured once,
put into a script somewhere and then forgotten about.

> > A lot of other manufacturers has also started doing things the Cisco
> > way.  If you don't have a Cisco router available, you can fx. use a
> > Windows XP box.  Type 'netsh' in a command prompt, then 'help'.  Or
> > alternatively 'netsh help'.  You get the idea :-).
> 
> Is this and interactive interface where you have hit 'tab' at anytime
> and it either completes the current word, or lists options? (For me,
> that is the 'kermit' interface, as kermit was the first program I used
> which had it).

I'd have to vote with Neil on this.  mdadm is going to be used in lots
of scripts.  System startup/shutdown scripts especially.  It's current form
is awesome for that.  Throw the right args together and you can do
anything.  As soon as it's interative, we might as well use a mouse...
::-P


-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
