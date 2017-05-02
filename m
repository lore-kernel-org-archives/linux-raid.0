From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Fwd: Please Help! Degraded Raid6
Date: Wed, 3 May 2017 00:01:54 +0200
Message-ID: <20170502220154.GA12721@metamorpher.de>
References: <C89BFE2F-0C7A-47CA-A970-EA90C0FF053A@gmx.de>
 <C7A7AD68-1ABB-4186-8228-BC89B95E4571@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C7A7AD68-1ABB-4186-8228-BC89B95E4571@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd <berndman80@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 02, 2017 at 11:11:10PM +0200, Bernd wrote:
> berndman@berndman:~$ sudo mdadm --examine /dev/sd[a-z]

You're using the wrong devices in your commands 
so the output is not the least bit interesting.

> /dev/sda:
>    MBR Magic : aa55
> Partition[0] :   3907027120 sectors at         2048 (type fd)
> /dev/sdb:
>    MBR Magic : aa55
> Partition[0] :   3907027120 sectors at         2048 (type fd)

> /dev/sdh:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x2
>      Array UUID : 26f8d8f1:530a3a85:31e4df5e:adc64cb8

Well except for this but need all of them.

>     Update Time : Fri Jul 10 22:32:34 2015

I hope it's not yet another case of a drive dropped out back 
in 2015 and you never doing anything about it in two years... 
Monitoring and instant email notification, is it that difficult?

Regards
Andreas Klauer
