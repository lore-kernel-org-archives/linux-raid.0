From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Resizing raid-1 on replacing failed disk
Date: Mon, 25 Oct 2004 15:14:57 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16764.35793.517769.857365@cse.unsw.edu.au>
References: <200410230541.i9N5fuN10579@www.watkins-home.com>
	<4179FADF.40806@classforge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from matt brennan on Saturday October 23
To: matt brennan <raid@classforge.com>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 23, raid@classforge.com wrote:
> 
> Could someone else please comment on the overall feasibility of resizing 
> a raid-1 array to physically larger disks via this process?
> 

Just adding a larger drive will not make a raid-1 larger.  
To make a raid-1 larger once all component drives (or partitions) are
large enough you have to either:
  1/ recreate the array (mdadm -C ....)
  2/ resize the array using a very recent 2.6 kernel and mdadm 1.7.0
      or later.

NeilBrown
