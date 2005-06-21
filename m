From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: from raidtools2 to mdadm
Date: Tue, 21 Jun 2005 15:54:04 +1000
Message-ID: <17079.43900.652982.735401@cse.unsw.edu.au>
References: <42B7A866.1080802@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Clemens Schwaighofer on Tuesday June 21
Sender: linux-raid-owner@vger.kernel.org
To: Clemens Schwaighofer <cs@tequila.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 21, cs@tequila.co.jp wrote:
> Hi,
> 
> as debian changed their package from raidtools2 to mdadm and left us
> users out in the cold (no mdadm.conf craeted, lsraid commands left in
> crontab, etc), I am now a bit worried if the command

Unfortunate...

> 
> #> mdadm --detail --scan>> mdadm.conf
> 
> is enought to get the raid started the next time I have to reboot
> the box.

1/ remove the 'devices=' parts.  Then it should be ok, providing there
   is a suitable DEVICES line at the top.
2/ If you were depending on 'raidstart' to start your arrays before,
   mdadm will definitely be more reliable (which is to say that it
   should still work if you lose the first drive of your array...)
3/ Best way to find out is to try it!

> 
> Until now I used only the raidtools (raidhotadd, lsraid, etc). Is there
> somehwere a reference like what raidhotadd would be in mdadm
> command?

Well, there is the man-page for mdadm.  An understanding is always
better than a cheat-sheet...

But raidhotadd /dev/mdX /dev/hdY  -> mdaddm /dev/mdX --add /dev/hdy
    s/add/remove/
    raidstop -> mdadm --stop

There is no real equivalent for mkraid. mdadm --create does the same
thing in a very different way.

NeilBrown
