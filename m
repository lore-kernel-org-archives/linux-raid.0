From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raidreconf error
Date: Fri, 12 Sep 2003 15:18:51 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.22331.898383.849144@notabene.cse.unsw.edu.au>
References: <6B238F130041BF46AF3592E6700E7E14770639@panda.eea.eu.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cristian Banciu on Thursday September 11
To: Cristian Banciu <Cristian.Banciu@eea.eu.int>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 11, Cristian.Banciu@eea.eu.int wrote:
> Hi,
> 
> I have done a software raid5 with 5 scci disks. Now I want to add one more disk to the current configuration without loosing data. But for some unkown reason the operation fails. Has anyone any idea why could I make this thing working ?
> 
> Thank you very much!
> 
> 
> #raidreconf -o /etc/raidtab -n /etc/raidtab.new -m /dev/md0
> Working with device /dev/md0
> Parsing /etc/raidtab
> Parsing /etc/raidtab.new
> Your on-disk array MUST be clean first.

At a guess, you still have /dev/md0 active.
Use "mdadm -S /dev/md0" or "raidstop /dev/md0" to stop it, then try
again.

NeilBrown
