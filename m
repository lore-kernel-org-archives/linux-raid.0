From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: RAID1 sync() slowness
Date: Thu, 12 Aug 2004 19:55:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408121955.12816.maarten@ultratux.net>
References: <Pine.LNX.4.44.0408101949300.10066-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408101949300.10066-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 11 August 2004 01:58, Mark Hahn wrote:

>
> yucko!  running lots of separate raided partitions across the same
> two disks is a mis-design.  the problem is that unless you almost
> never do IO on some partitions, you'll wind up shuttling the heads
> around an obscene amount of time.

...just as you would when you wouldn't have raid-1 but just a single drive 
with multiple partitions.  And that is a very common and sensible thing to 
do, especially on production servers!  People who run /usr, /var, /home all 
off the single / filesystem aren't taking due diligence when it comes to 
security IMO.  
That this may degrade performance may very well be, but it doesn't make having 
seperate partitions any less desired / needed in a production environment.  

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

