From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Array of disks attached to multiple controllers
Date: Wed, 15 Sep 2004 06:31:47 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16711.21811.373714.356892@cse.unsw.edu.au>
References: <4146FB2F.9080103@opf.slu.cz>
	<200409141459.i8EExv332327@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Guy on Tuesday September 14
To: Guy <bugzilla@watkins-home.com>
Cc: 'Lukas Kubin' <kubin@opf.slu.cz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 14, bugzilla@watkins-home.com wrote:
> Well I have a clue!
> <Device size> X (<Number of disks> - 1)
> 195360896 X (16-1) = 2930413440 (a very nice number!)
> 
> I think you have crossed a 2T limit.
> Subtract 2T from the expected size and you get you size.
> 2930413440 - 2^31 = 782929792  (This is your size!)
> 
> 2^31 = 2T. (we have 1K blocks)
> 
> You have exceeded a 2T limit somewhere.  I don't know where the limit is.  I
> thought I read that devices were limited to 2T, but arrays could be larger.
> Maybe you have an older kernel that only supports 2T.  My 14 disk monster
> array is just over 200Gig, so I have not had this problem.  A new kernel may
> help, but I don't know.  Time for Neil to help! :)

2.4 kernels on 32bit processors cannot handle devices larger than 2^32
  sectors (2T).  Maybe not even bigger than 1T, I'm not sure.

2.6 kernels can if you select CONFIG_LBD (Large Block Devices).

> 
> I think you will be fine if you only use 11 disks!
> 195360896 * (11-1) = 1953608960 (this is under the 2T limit).

Worth a try, as is using 2.6

NeilBrown
