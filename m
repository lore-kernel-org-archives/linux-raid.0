From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: two questions re. proactive recovery and forced assembly
Date: Fri, 09 May 2008 08:23:21 +1200
Message-ID: <48236139.70301@sauce.co.nz>
References: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>	 <48013976.6020705@sauce.co.nz>	 <c4985c940805070422lfde5f6bhd510c12d2f2d0f2f@mail.gmail.com>	 <482253C1.5060803@sauce.co.nz> <c4985c940805080401k5851a9d5n35d12d6d07ff2496@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c4985c940805080401k5851a9d5n35d12d6d07ff2496@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

rosenfield.albert@gmail.com wrote:

> But will this assemble a RAID5 array where the event counters are out
> of sync on not one, but two disks?

I cannot read code unfortunately, but the man page states:

" --force

Insist that mdadm accept the geometry and layout specified without 
question."

I would therefore expect it to.

Regards,

Richard
