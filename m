From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Using raidreconf to create raid0 from non-raid works, but df is wrong
Date: Thu, 8 Jul 2004 13:23:32 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16620.48692.991526.480905@cse.unsw.edu.au>
References: <07ec01c46498$240dd770$6401010a@stan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Billings on Wednesday July 7
To: Mike Billings <mike@carolina.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 7, mike@carolina.rr.com wrote:
> Hi,
> 
> I originally had a 250G ide drive on my system.  I added a second 250G and
> used raidreconf to go from non-raid to raid using "raidreconf -i
> /dev/hde1 -n /etc/raidtab -m /dev/md0".  The conversion suceeded, mdadm
> reports that everything is ok, and the new raid0 works fine but df reports
> the wrong size.  Is there any way to get df to report the correct size
> without wiping the data?  Could I have done something with raidreconf
> differently to avoid this?

If it is an ext2 or ext3, then resize2fs is what you need now.
If some other filesystem.... maybe some other tool.

NeilBrown
