From: Thomas Steudten <alpha@steudten.com>
Subject: Re: md raid oops on 2.4.25/alpha
Date: Sun, 28 Mar 2004 19:30:22 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40670BAE.4060901@steudten.com>
References: <20031027141358.GA26271@gamma.logic.tuwien.ac.at> <20040327164153.GA7324@gamma.logic.tuwien.ac.at> <20040328160246.GA19965@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040328160246.GA19965@gamma.logic.tuwien.ac.at>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Looks like the well known bad assembler code with gcc.
On the alpha you see the problem first in the
raid1_read_balance() code sequence..
You should use gcc 3.3.2 better 3.3.3.
For alpha find the binary rpms here:
http://www.steudten.org/alpha/packages/

Tom

Norbert Preining wrote:
> Hi Ingo, hi Neil, hi lists!
> 
> We have some problems with the md code on alpha. We get regular oops
> when using the md raid1. Here we got another oops when fsck (at boot 
> time) the raid:
> This was after a fresh reboot. As long as only the raid is *not* mounted
> of fsck the machine works without any oops.
> 
> I also can mount the hard disks *without* raid directly as hda1 and
> hdc1, and do NOT get any errors here, so I suspect that only the md code
> is the culprit.

>>>RA;  fffffc00004a8d7c <raid1_make_request+1dc/480>
> 
> 
>>>PC;  fffffc00004a8aa4 <raid1_read_balance+104/200>   <=====

