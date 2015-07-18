From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Reversing parity recalculation on out-of-order RAID 6 array
Date: Sat, 18 Jul 2015 13:43:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1507181342220.11810@uplift.swm.pp.se>
References: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com> <alpine.DEB.2.02.1507180731040.11810@uplift.swm.pp.se> <CAFcup8G230TBec=FzM45GqUkb218yWcYiJJiHDNOkv9MQHkF0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFcup8G230TBec=FzM45GqUkb218yWcYiJJiHDNOkv9MQHkF0g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Reddie <steven.reddie@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Jul 2015, Steven Reddie wrote:

> I need to reverse these disk writes across then entire length of the 
> array, after which I can reassemble the array in the correct order.

If you did not use --assume-clean, and had the wrong parity order and the 
array was "resynced", I don't see how you did not irrevocably overwrote 
important information and you now can't reverse this.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
