From: Daniel Browning <db@kavod.com>
Subject: Re: What to do about "ignoring %s as it reports %s as failed"?
Date: Sat, 12 Jan 2013 13:18:52 -0800
Message-ID: <201301121318.52920.db@kavod.com>
References: <201301101101.01371.db@kavod.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301101101.01371.db@kavod.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 10 January 2013 11:01:01 am Daniel Browning wrote:
> Hello, folks. What should I do about the following error?
> 
> 	mdadm: ignoring /dev/sdd1 as it reports /dev/sdb1 as failed
> 

I was never able to find a way around that error, so I had completely 
written off the failed array. But today I rebooted the server (for a 
completely unrelated reason) and when it came back up, the failed array 
started working just fine, automatically. No error like the above. The array 
passed fsck with a clean bill of health, but now I'm checking for silent 
corruption by comparing against backups (except files that have a newer mod 
time).

I would still be interested in knowing what I *should* have done when 
encountering that error, and if there was any other solution aside from 
rebooting. If not, I have to say I'm disappointed that a reboot is required 
to fix this type of issue, because I thought that was a Windows thing, not 
something to expect from Linux and/or mdadm.

One cooincidence that struck me as very funny was that this morning I read 
the following comic:

http://thedoghousediaries.com/4822

But I still didn't think that rebooting would help my raid issue, so I 
didn't bother to reboot. Later on when I rebooted for a different reason, I 
realized just how timely that comic was.

Special thanks to one "frostschutz" in the freenode #linux-raid IRC channel, 
who helped me out with all this.

--
Daniel Browning
Kavod Technologies
