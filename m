From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Why is a "init 0" halt not bringing my raid5 up clean?
Date: Fri, 21 Feb 2003 11:13:41 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15957.28469.105290.843245@notabene.cse.unsw.edu.au>
References: <20030220162547.GE19609@rdlg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert L. Harris on Thursday February 20
To: "Robert L. Harris" <Robert.L.Harris@rdlg.net>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday February 20, Robert.L.Harris@rdlg.net wrote:
> 
> 
> I have a server with 4 RAID5 arrays.  I just went in and did an init0 on
> the box to remove the fourth array and replace all 4 disks to create a
> new RAID5 array (long story).  When I brought the box back up md0 and
> md1 were both showing their 1st disk as faulty.  They were both clean
> and error free before the init 0.
> 
> This happens a good bit.  Any reason why?
> 

Probably, but you haven't provided enough detail.  
Maybe if you say a bit more about how the arrays are configured, and
how they are assembled and started.

NeilBrown
