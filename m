From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 01:40:26 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405200140.26636.maarten@vbvb.nl>
References: <200405192218.i4JMI9B16930@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405192218.i4JMI9B16930@www.watkins-home.com>
Content-Disposition: inline
To: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday 20 May 2004 00:18, Guy wrote:
> I think they fudge the MTBF!  They say 1,000,000 hours MTBF.
> That's over 114 years!
> Drives don't last anywhere near that long.

Hear hear!  (although the MTBF does mean entirely something else, its use in 
marketing, and the ensuing misplaced consumer-confidence, is atrocious.)

> Someone I know has 4 IBM disks.  3 of 4 have failed.
> 1 or 2 were replaced and the replacement drive(s) have failed.

Yeah, it's weird.  For me Western Digital drives have failed consistently on 
me, but I've had very good experience with Maxtor (read: Quantum) and Hitachi 
(read: IBM).  As opposed to other posts in this thread...

> All still under warranty!  He gave up on IBM since the MTBF seems to be
> less than 1 year.  This was about 2-3 years ago.  He mirrors thing most of
> the time.

One thing I've come to believe over the years is that heat is a very important 
factor that's killing drives.  So I now take great care in ensuring good heat 
dissipation from the drives. This entails amongst others that you should 
never 'sandwich' drives in their 3,5" slots (I can't believe case 
manufacturers still have not woken up to this need!). Instead I often arrange 
for them to go in 5,25" slots so they have plenty of air around. If I need to 
put them in 3,5" slots I always leave 1 unit space around a drive.
In the servers I deploy I take bigger measures, like a bigass 120mm fan just 
in front of the drives (accomplished either by dremel or by case design)

> In the past I have almost never had a disk failure.  Almost all on my
> drives became too small to use before they failed.  The drives ranged from
> 10Meg to 3Gig.  Drives larger than 3Gig seem to fail before you out grow
> them.

Hm, no.  I did observe some real bad brands / series, even all the way back to 
30 MB(M!) RLL drives and a particularly bad batch of 48 MB scsi-1 seagate 
ones. But I'll admit that those were the exception to the rule way back then.

> I would love to see real live stats.  Claimed MTBF and actual MTBF.

MTBF is measured in a purely statistical way, not taking any _real_ wear and 
tear or aging into account.  They run 10000 drives for a month and 
extrapolate the MTBF from there. The figure is close to meaningless. For 
starters, it does not guarantee _anything_. If you have 5 out of 5 failures 
within the first six months, that still fits fine inside the statistical 
model, unless a lot of others have that same rate of failure. Secondly, one 
just cannot extrapolate the life expectancy of a drive in this way and get 
useable figures.  I can take a statistical test with 20.000 babies during a 
year, and perhaps extrapolate from there that the MTBF for humans is 210 
years.  And boy, we all know that statistic paints a dead wrong picture...!   

You need to disregard any and all MTBF values.  They serve no purpose for us 
end-users. They only serve a purpose for vendors (expected rate of return), 
manufacturers and, probably, insurance companies...

> I just checked Seagate and Maxtor.  They don't give a MTBF anymore.
> When did that happen!

Well, It was more or less useless anyway. I can tell you just offhand that you 
can lengthen the life expectancy of a drive maybe four-fold if you make sure 
it stays below 35 degrees celsius its entire life, instead of ~45 degrees.
Don't hold me up on that, but you know what I mean, and it is true. :-)  

> Just Service life and Warranty.
> Anyway the best indicator of expected life, the warranty.  If the
> manufacture thinks the drive will only last 1 or 3 years (depending on size
> or model), who am I to argue?

Times have indeed changed. 5 or 10 years ago, I would not have hesitated to 
put all my data (of which I had little or no backups) on a single 120MB or 2 
GB disk.  Nowadays, I hardly ever put valueable data on single disks. Either 
it has good backups or it goes onto raid 1 or 5 arrays.  I've seen it happen 
too many times at customers... I do take my precautions now.
(I've been there myself too, and got the T-shirt...)

Not that that guarantees anything... The lightning might strike my 8-disk 
fileserver and take out everything. The lightning may hit my house as well 
and take any and all but some very very old backups along with it.
But still, chances are much lower and that is what counts, innit ?

If / when a real disaster happens, I'll still live through it. But I just 
*need* it to have a much better reason than the ubiquitous drive-failure, 
user-error of virus, because *that* I will not forgive myself...

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER

