From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Thu, 25 Feb 2010 09:41:20 -0800
Message-ID: <adf93d751002250941t4ba2a222ua0406bc3c95e90@mail.gmail.com>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at>
	 <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
	 <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at>
	 <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at>
	 <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B86A943.3040804@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 25, 2010 at 8:45 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 25/02/2010 08:05, Giovanni Tessore wrote:
> [...]
>>
> I do think we urgently need the hot reconstruction/recovery feature, so
> failing drives can be recovered to fresh drives with two sources of data,
> i.e. both the failing drive and the remaining drives in the array, giving us
> two chances of recovering every sector.

I was one of those 4 cases in the part month.  I would have certainly
benefited from this when I tried to replace a failing drive on my old
raid-5.  But  I think actually the redundancy you desired can be
achieved by running a raid-6 at the degraded mode (with 1 missing
drive).

Do I miss something?  If this is the case, shouldn't we all
be doing this instead of using the raid-5?


>
> Cheers,
>
> John.

DS
