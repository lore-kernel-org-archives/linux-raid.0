From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: new superblock and raid10 support in mdadm
Date: Thu, 23 Dec 2004 09:58:41 +1100
Message-ID: <16841.64545.299938.448549@cse.unsw.edu.au>
References: <000201c4e875$e654c7b0$6d01a8c0@asitest>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from BO MOON on Wednesday December 22
Sender: linux-raid-owner@vger.kernel.org
To: BO MOON <bmoon@anthologysolutions.com>
Cc: 'rich turner' <rich@storix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 22, bmoon@anthologysolutions.com wrote:
> Hello again,
> 
> I will re-iterate my question for raid10 or raid01.
> 1.  Is raid10.c in ONLY linux2.6.xx? no support for 2.4.xx?

2.6 only

> 2.  Does raid10.c support for RAID10 only? Or for both raid10 and
> raid01?

raid10.c supports an arrangement where data is both striped and
mirrored. 
The difference between raid1+0 and raid0+1 (which also both stripe and
mirror) is not relevant when the striping and mirroring is done in the
one module.


> 3.  we can build raid10 or raid01 on linux2.4.xx without raid10.c code.
>     What issues or bugs does this code take care of?

raid10.c provides more flexibility and simpler management.

> 4.  What rev of mdadm should be used for raid10? Mdadm1.7 or greater?
> 

Should work with 1.7.0, but would recommend upgrading to 1.8.0 anyway
(NOT 1.8.1).

NeilBrown
