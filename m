From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Raid performance
Date: Tue, 06 Apr 2010 07:49:45 +1200
Message-ID: <4BBA3ED9.6040800@sauce.co.nz>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com> <20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com> <20100402110506.GA16294@rap.rap.dk> <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com> <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com> <4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org> <4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org> <4BB91FBC.10504@sauce.co.nz> <4BB9C76E.7080607@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB9C76E.7080607@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Mark Knecht <markknecht@gmail.com>, Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

MRK wrote:

> However, if really the total number of IOPS is the bottleneck in SATA
> with the 3.0gbit/sec LSI cards, why they don't slow down a single SSD
> doing 4k random I/O?

We don't know, as we have no information for one of these SSDs attached 
to an LSI SAS controller.

I'm not sure this is an apples to apples comparison. The SSD is one 
device probably connected  to a motherboard SATA controller channel.

The RAID array is 16 devices attached to a port expander in turn 
attached to a SAS controller. At a most simplistic level, surely the SAS 
controller has overhead attached to which drive is being addressed.


> I think if you use dd to read from the 16 underlying devices
> simultaneously, independently, and not using MD, (output to /dev/null)
> you should obtain the full disk speed of 1.4 GB/sec or so (aggregated).
> I think I did this test in the past and I noticed this. Can you try? I
> don't have our big disk array in my hands any more :-(

I'll bear it in mind next time I am in a position to try it.

Regards,

Richard
