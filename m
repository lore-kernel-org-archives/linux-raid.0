From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Spare disk could not sleep / standby
Date: Wed, 09 Mar 2005 09:11:38 +0400
Message-ID: <422E858A.5090602@wasp.net.au>
References: <422D327D.11718.F8DB3@localhost>  <200503080414.j284EG510309@www.watkins-home.com>  <16941.11443.107607.735855@cse.unsw.edu.au>  <62b0912f0503072120776e0b56@mail.gmail.com>  <16941.14813.465306.72004@cse.unsw.edu.au>  <62b0912f05030721465e84e4da@mail.gmail.com>  <16941.16439.595486.231598@cse.unsw.edu.au>  <62b0912f050307222494fe17f@mail.gmail.com>  <422D625C.5020803@medien.uni-weimar.de> <62b0912f0503080057488f13ad@mail.gmail.com> <422D83B1.5060709@medien.uni-weimar.de> <Pine.LNX.4.56.0503081133140.4055@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <Pine.LNX.4.56.0503081133140.4055@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> 
> I'm in the middle of building up a new home server - looking at RAID-5 or
> 6 and 2.6.x, so maybe it's time to look at all this again, but it sounds
> like the auto superblock update might thwart it all now...

Nah... As far as I can tell, 20ms after the last write, the auto superblock update will write the 
array as clean. You can then spin the disks down as you normally would after a delay. It's just like 
a normal write. There is an overhead I guess, where prior to the next write it's going to mark the 
superblocks as dirty. I wonder in your case if this would spin up *all* the disks at once, or do a 
staged spin up, given it's going to touch all the disks "at the same time"?

I have my Raid-6 with ext3 and a commit time of 30s. With a idle system, it really stays idle. 
Nothing touches the disks. If I wanted to spin them down I could do that.

The thing I *love* about this feature, is when I do something totally stupid and panic the box, 90% 
of the time I don't need a resync as the array was marked clean after the last write. Thanks Neil!

Just for yuk's, here are a couple of photos of my latest Frankenstein. 3TB of Raid-6 in a Midi-Tower 
case. Had to re-wire the PSU internally to export an extra 12v rail to an appropriate place however.

I have been beating Raid-6 senseless for the last week now and doing horrid things to the hardware. 
I'm now completely confident in its stability and ready to use it for production. Thanks HPA!

http://www.wasp.net.au/~brad/nas/nas-front.jpg
http://www.wasp.net.au/~brad/nas/nas-psu.jpg
http://www.wasp.net.au/~brad/nas/nas-rear.jpg
http://www.wasp.net.au/~brad/nas/nas-side.jpg


Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
