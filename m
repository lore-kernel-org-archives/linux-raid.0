From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Invalid argument error on raid5 create
Date: Tue, 9 Jul 2002 15:01:11 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15658.28183.219550.723620@notabene.cse.unsw.edu.au>
References: <001f01c22632$ad349580$0200a8c0@gandalf>
	<15657.19046.986108.967800@notabene.cse.unsw.edu.au>
	<00cd01c226db$2f71ddc0$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bo on Monday July 8
To: bo <bo@sosnetwork.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 8, bo@sosnetwork.net wrote:
> Neil,
> 
> I am trying to create the RAID 5 array with
> 
> >mdadm -C /dev/md0 -l5 -n6 -x1 -prs /dev/hd[bcdefgh]
> 
> However, I am getting the following error message;
> 
> >mdadm: RUN_ARRAY failed: Invalid argument
> 
..
> 
> Any clue?

Maybe the raid5 personality isn't loaded into the kernel...
What does 
  cat /proc/mdstat
say?
Are there any message in
   dmesg
after the failure?

NeilBrown
