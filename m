From: <me@heyjay.com>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under      Linux
Date: Fri, 4 Jun 2004 08:31:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00da01c44a38$81e37cd0$6705a8c0@a30>
References: <16576.5818.189830.563396@cse.unsw.edu.au><40287.194.60.85.4.1086343951.squirrel@194.60.85.4> <16576.26485.323313.378671@cse.unsw.edu.au>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The simplest way to access this functionality is with
> 
>     mdadm --create /dev/md/XX --auto=partition --level= ....
> 

How does in know how big to build the partitions?
How does it know how many partitions?

Can you do it with out building the partitions automatically
and instead it will just build /dev/mdXX and then I can use
fdisk, sdisk, cfdisk... to build my partitions?

Thanks
Jay
