From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Recovery raid5 after sata cable failure.
Date: Mon, 18 Jul 2005 14:15:40 +0400
Message-ID: <42DB814C.1070409@wasp.net.au>
References: <42db7d1e.6cc951d1.55b4.ffffb383@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42db7d1e.6cc951d1.55b4.ffffb383@mx.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Zafra <fzafra@gmail.com>
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francisco Zafra wrote:
> Hi Neil, 
> Since some hours I am trying to solved it with the last version:
> root@Torero-2:~ # mdadm --version
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005
> 
> With the same results :(
> 
> I really don't think it is locked I dd it in act of desperation and I have
> no problems:
> root@Torero-2:~ # dd if=/dev/zero of=/dev/sdh bs=1k count=1000
> 1000+0 records in
> 1000+0 records out
> 1024000 bytes transferred in 0.417862 seconds (2450570 bytes/sec)
> 

Asking a silly question perhaps..

fuser /dev/sdh

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
