From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Linux Raid performance
Date: Mon, 05 Apr 2010 11:24:44 +1200
Message-ID: <4BB91FBC.10504@sauce.co.nz>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com> <20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com> <20100402110506.GA16294@rap.rap.dk> <x2q7efa8a7d1004021055oe2e832ccl8877e9171b8f3442@mail.gmail.com> <l2j5bdc1c8b1004021739z969b99v6011fcc6fddd470a@mail.gmail.com> <4BB69670.3040303@sauce.co.nz> <4BB7856C.30808@shiftmail.org> <4BB79D76.7090206@sauce.co.nz> <4BB8A979.3020502@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB8A979.3020502@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: Mark Knecht <markknecht@gmail.com>, Learner Study <learner.study@gmail.com>, linux-raid@vger.kernel.org, keld@dkuug.dk
List-Id: linux-raid.ids

MRK wrote:

> If this is so, the newer LSI controllers at 6.0gbit/sec could be able to
> do better (they supposedly have a faster chip). Also maybe one could buy
> more controller cards and divide drives among those. These two

Yes, both of these would work.

Someone posted previously on this list and was writing at 1.7GB/s using 
10 x 15K SAS drives md RAID0. He did mention the troughput was higher 
with the LSI SAS2 cards, even with SAS1 port expanders connected.

Regards,

Richard
