From: Tony Arcieri <tony@medioh.com>
Subject: Re: md tries to assemble md_d0 instead of md0
Date: Sun, 23 Aug 2009 13:54:29 -0600
Message-ID: <c7e6b2b00908231254u423ecfbch12cb113b49f5b59d@mail.gmail.com>
References: <c7e6b2b00908230907v4a02a76bt9641e8dca009d64e@mail.gmail.com>
	 <c7e6b2b00908230912w59f1998wd109272b6904e03b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c7e6b2b00908230912w59f1998wd109272b6904e03b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I booted with a LiveCD, which brought md0 up in the following configuration:

md0 : active raid5 sdg1[4] sdf1[3] sde1[2] sdb1[0]
      3907039744 blocks level 5, 64k chunk, algorithm 2 [5/4] [U_UUU]

Unfortunately it also mounted it read/write.  On a subsequent reboot
back to my original install I'm getting:

md_d0 : inactive sde1[2](S)
      976759936 blocks

And when I mdadm --assemble --scan -fv:

md0 : active raid5 sdb1[0] sdg1[4] sdf1[3] sdc1[1]
      3907039744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UU_UU]

md_d0 : inactive sde1[2](S)
      976759936 blocks

(note the odd drive out changed from sdc to sde)

Any idea WTF is going on here?  I already need to repair the
filesystem on there because of this.  When I mount it all my data is
gone.  This is extremely annoying to say the very least.

-- 
Tony Arcieri
