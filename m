From: Neil Brown <neilb@suse.de>
Subject: Re: Problem with growing raid1 array (2.6.16-rc1-git2)
Date: Fri, 17 Feb 2006 21:34:42 +1100
Message-ID: <17397.42690.217096.440721@cse.unsw.edu.au>
References: <20060217101048.GA11239@asalmela.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Antti Salmela on Friday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Antti Salmela <asalmela@iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 17, asalmela@iki.fi wrote:
> I had two 80 GB disks in a raid1 set and wanted to replace them with new
> 300 GB disks. Replacing went fine and 'mdadm --grow --size max' seemed to
> work fine until I tried to run 'pvresize'. pvresize complained that
> md device was smaller than before and refused to resize and soon after
> that there was also complaints about access beyond end of device.
> 
> After restarting md array everything worked fine and I was able to
> resize physical volume successfully.

Thanks for the comprehensive report.

This was fixed on the 2nd Feb by

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6d89332b776fc11bac0073209e44ec8f39831e4e

which is slightly more recent than the -rc1-git2 you were using.

NeilBrown
