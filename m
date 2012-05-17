From: George Shuklin <george.shuklin@gmail.com>
Subject: Re: Add set bad lba function in md-faulty module.
Date: Thu, 17 May 2012 15:49:29 +0400
Message-ID: <4FB4E5C9.5090103@gmail.com>
References: <201205151949130004425@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205151949130004425@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 15.05.2012 15:49, majianpeng wrote:
> Hi all:
> 	In order to test md code, sometime we need  simulate read/write harddisk error.
> 	Using hdparm --make-bad-sector to  simulate  read error.But I did not find way of  simulating write-error.
> 	I tested md-faulty module, it can do this.But it is not provide the function link hdparm --make-bad-sector,which did not set lba.
> 	Using hdpamr --make-bad-sector to  simulate read error can cause some problem.
> 	It will cause ata commnd reset,disk reset and so on.It take too log time.
> 	So I think add a function in md-faulty which can set read/write lba.
> 	How about ?
> 											
>   				
How about using an iscsi at localhost? Export disk via ISCSI target, 
connect to it with initiator. With iptables and open-iscsi settings you 
can precisely control error behavior and imitate all kinds of errors 
(including timeouts).
