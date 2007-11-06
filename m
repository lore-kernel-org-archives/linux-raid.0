From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Software raid - controller options
Date: Tue, 06 Nov 2007 17:08:39 +1300
Message-ID: <472FE8C7.10100@sauce.co.nz>
References: <1194315635.17361.20.camel@localhost.localdomain>	 <472FD6A4.5030907@sauce.co.nz> <1194319214.17361.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194319214.17361.36.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lyle Schlueter wrote:

> Do you know of any concerns of using all the ports on a motherboard?
> Slowdowns or anything like that?

I've one box here that's using all six onboard ports on an Nvidia MCP55 
controller.

Two ports are a RAID 1 for the OS and the other 4 have 4 x 500GB drives 
as a RAID 5.

It flies along at the speed I would expect - the array started out as a 
3 drive RAID5 and after I'd grown it to 4, I tested it with the 
filesystem 60% full and got 160MB/s writes and 178MB/s reads.

Regards,

Richard
