From: Neil Brown <neilb@suse.de>
Subject: Re: SLES 9 SP3 and mdadm 2.6.1 (via rpm)
Date: Tue, 12 Jun 2007 17:34:55 +1000
Message-ID: <18030.19615.898281.457910@notabene.brown>
References: <20070612072408.19140@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thorsten Wolf on Tuesday June 12
Sender: linux-raid-owner@vger.kernel.org
To: Thorsten Wolf <T_Wolf@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 12, T_Wolf@gmx.net wrote:
> Hello everyone.
> 
> I've got a SLES9 SP3 running and I've been quite happy with it so far.
> 
> Recently, I've created a 4 disk spanning RAID-5 on our company
> server. Runs quite nice and we're happy with that too. I created
> that RAID using the SLES mdadm (1.4 I believe) package. 
> 
> After discovering that there is a much newer mdadm out here (2.6.1),
> I decided to upgrade. It went just fine. Raid still running at 120
> MB/sec. 
> 
> After adding a disk to the raid, which went fine as well...... BUT:
> 
> The added disk /dev/sda1 shows up in /proc/mdstat, but does not have
> the "spare (s)" flag. 
> 
> Plus... the --grow doesn't work...
> 
> I get the: mdadm: /dev/md0: Cannot get array details from sysfs
> error which has been discussed before. Can it be that this is caused
> by the 2.6.5-7.2xx Kernel? Any ideas? 

Yes.  All of your issues are caused by using a 2.6.5 based kernel.
However even upgrading to SLES10 would not get you raid5-grow.  That
came a little later.  You would need to compile a mainline kernel or
wait for SLES11.

NeilBrown
