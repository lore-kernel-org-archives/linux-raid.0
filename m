From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 code ok with 2TB + ?
Date: Sun, 28 Nov 2004 13:19:43 -0500
Message-ID: <200411281819.iASIJmN00402@www.watkins-home.com>
References: <41A9AF2C.5010706@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41A9AF2C.5010706@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'Stephan van Hienen' <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Your 2.2T array is not as big as you think!

1TB = 2^40 not 1*10^12
Maybe depending on if you are buying disk drives, or selling them! :)
But when related to the 2TB limit it is 2^40.

2206003968 blocks
Divide by 1024 gives you 2154300.75 meg
Divide by 1024 gives you 2103.8093 Gig
Divide by 1024 gives you 2.0545 TB
So you are just over 2TB. by 58520320 blocks or 55.8 Gig.

The only reason I am being exact is that you have not tested disk I/O beyond
2TB as much as you think.  Once, someone else made a similar 2T claim, after
the math he was really below 2T.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Sunday, November 28, 2004 5:58 AM
To: Stephan van Hienen
Cc: linux-raid@vger.kernel.org
Subject: Re: raid5 code ok with 2TB + ?

Stephan van Hienen wrote:
> in the past the raid5 code was 32bits internal
> and the limit was 2TB
> 
> is this fixed in the 2.6.x ?

I hope so, I have been using it on a 2.2TB raid-5 for months now. (I have
completely filled the 
partition and e2fsck it monthly so I would hope any glitches should have
surfaced by now)

brad@srv:~$ cat /proc/mdstat
Personalities : [raid0] [raid5] [raid6]
md2 : active raid5 sdl[0] sdm[2] sdk[1]
       488396800 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 sda1[0] sdj1[9] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4]
sdd1[3] sdc1[2] sdb1[1]
       2206003968 blocks level 5, 128k chunk, algorithm 0 [10/10]
[UUUUUUUUUU]


-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

