From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 6 failing to assemble after machine power loss now, with 1
 disk only failed, seems to think its a raid0 array
Date: Wed, 30 Mar 2016 18:17:04 -0400
Message-ID: <56FC5060.4020502@turmel.org>
References: <CAAgcXJEgLxSaa7x3YO=CuMXS9hPPfPMiUtebQ4RB4F6dmQPd1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAgcXJEgLxSaa7x3YO=CuMXS9hPPfPMiUtebQ4RB4F6dmQPd1g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Knight <madcornishprojectionist@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/30/2016 05:19 PM, Peter Knight wrote:
> Hi,
> 
> I hope someone can explain what is going on and hopefully help me
> recover my data.

> What is causing this? and how can I get it reassembled so I can read the data?

When mdadm assembles an array during boot that has fewer devices than
when it was last shut down (cleanly), it generally declines to start it.

Probably, all you need is:

mdadm --run /dev/md126

{ --detail may not be accurate on an inactive device.  The member
--examine data is trustworthy. }

Phil
