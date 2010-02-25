From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Thu, 25 Feb 2010 18:31:35 +0000
Message-ID: <4B86C207.6030304@anonymous.org.uk>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at>	 <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>	 <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at>	 <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at>	 <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk> <adf93d751002250941t4ba2a222ua0406bc3c95e90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002250941t4ba2a222ua0406bc3c95e90@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/02/2010 17:41, Dawning Sky wrote:
> On Thu, Feb 25, 2010 at 8:45 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> On 25/02/2010 08:05, Giovanni Tessore wrote:
>> [...]
>> I do think we urgently need the hot reconstruction/recovery feature, so
>> failing drives can be recovered to fresh drives with two sources of data,
>> i.e. both the failing drive and the remaining drives in the array, giving us
>> two chances of recovering every sector.
> 
> I was one of those 4 cases in the part month.  I would have certainly
> benefited from this when I tried to replace a failing drive on my old
> raid-5.  But  I think actually the redundancy you desired can be
> achieved by running a raid-6 at the degraded mode (with 1 missing
> drive).
> 
> Do I miss something?  If this is the case, shouldn't we all
> be doing this instead of using the raid-5?

I think you must be missing something, yes. RAID-6 with one drive 
missing would have 2 chances of recovering each sector, but then so does 
RAID-5 with no drives missing. In either case, lose a drive and you need 
every sector on the remaining drives to be good to complete the 
reconstruction and keep the array up.

Cheers,

John.

