From: Neil Brown <neilb@suse.de>
Subject: Re: Array will not assemble
Date: Fri, 7 Jul 2006 10:06:57 +1000
Message-ID: <17581.42401.473236.453490@cse.unsw.edu.au>
References: <44AD9F2B.9090205@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Richard Scobie on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, richard@sauce.co.nz wrote:
> Perhaps I am misunderstanding how assemble works, but I have created a 
> new RAID 1 array on a pair of SCSI drives and am having difficulty 
> re-assembling it after a reboot.
> 
> The relevent mdadm.conf entry looks like this:
> 
> 
> ARRAY /dev/md3 level=raid1 num-devices=2 
> UUID=72189255:acddbac3:316abdb0:9152808d devices=/dev/sdc,/dev/sdd

Add
  DEVICE /dev/sd?
or similar on a separate line.
Remove
  devices=/dev/sdc,/dev/sdd

NeilBrown
