From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: mkraid -f error
Date: 01 Jul 2004 10:11:13 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1088694673.5376.320.camel@star2.austin.ibm.com>
References: <Pine.LNX.4.44.0406302128570.9507-100000@westhost38.westhost.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0406302128570.9507-100000@westhost38.westhost.net>
To: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2004-06-30 at 21:40, linux-lists@artelesys.com wrote:
> Hello.
> I am trying to  use mkraid "really forced" to rewrite the raid superblocks 
> on an existing raid1 set. MKraid exits reporting an error and suggesting 
> to look in the log for more information (dont see any listed in the log). 
> I've tried with the raid device unmounted and stopped when I do the mkraid 
> but still get this unspecific error message. 
> 
> Can anyone tell me what is causing this error message ?   
> 
> Regards,
> Arturo
> 

Instead of mdtools, I suggest that you use mdadm.  The latest stable
release is 1.6.0 .  mdadm -C will ask you before overwriting existing
superblock.

http://www.cse.unsw.edu.au/~neilb/source/mdadm/

Regards,
Mike T.

