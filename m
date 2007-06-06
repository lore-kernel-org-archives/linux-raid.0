From: Neil Brown <neilb@suse.de>
Subject: RE:  RAID 6 grow problem
Date: Wed, 6 Jun 2007 10:46:00 +1000
Message-ID: <18022.968.613733.320715@notabene.brown>
References: <2076428235.1181071281354.JavaMail.root@gateway.korstad.net>
	<Pine.LNX.4.64.0706051612400.5806@gheavc.wnzcbav.cig>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Nelson on Tuesday June 5
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 5, jnelson-linux-raid@jamponi.net wrote:
> 
> I have an EPoX 570SLI motherboard with 3 SATAII drives, all 320GiB: one 
> Hitachi, one Samsung, one Seagate. I built a RAID5 out of a partition 
> carved from each. I can issue a 'check' command and the rebuild speed 
> hovers around 70MB/s, sometimes up to 73MB/s, and dstat/iostat/whatever 
> confirms that each drive is sustaining approximately 70MB/s reads. 
> Therefore, 3x70MB/s = 210MB/s which is a bunch more than 133MB/s. lspci 
> -v reveals, for one of the interfaces (the others are pretty much the 
> same):

...
> 
> I'm trying to determine what the limiting factor of my raid is: Is it 
> the drives, ....

If look at the data sheets for the drives (I just had a look at a
Seagate one, fairly easy to find on their web site) you should fine
the Maximum Sustained Transfer Rate, which will be about 70MB/s for
current 7200rpm drives.

So I think the drive is the limiting factor.

NeilBrown
