From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --monitor
Date: Thu, 16 May 2002 20:11:43 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15587.34271.342444.898591@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.30.0205161032080.15557-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Danilo Godec on Thursday May 16
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 16, danci@agenda.si wrote:
> Hi!
> 
> I'm trying out mdadm on a new system I'm building and it seems fine so
> far. However, right now I'm tryoung the '--monitor' feature and
> unfortunately it seems to do nothing...
...
> [root]# cat /usr/local/sbin/raidalert:
> 
> #!/bin/bash
> #
> #
> 
> logger -p kern.crit -t RAID
> 


Try
   logger -p kern.crit -t RAID $*

the program doesn't get anything on stdin.  I just gets 2 or three
command-line arguments.

NeilBrown
