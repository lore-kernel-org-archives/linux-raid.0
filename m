From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Thu, 25 Feb 2010 16:45:55 +0000
Message-ID: <4B86A943.3040804@anonymous.org.uk>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at> <4B862F2C.5030302@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B862F2C.5030302@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/02/2010 08:05, Giovanni Tessore wrote:
[...]
> I see this is the 4th time in a month that poeple reports problem on 
> raid5 due to the read errors during reconstruction; it looks like the 
> 'corrected read errors' policy is quite a real concern.

If you mean md's policy of reconstructing from the other discs and 
rewriting when there's a read error from one disc of an array, rather 
than immediately kicking the disc that had a read error, I think you're 
wrong - I think md is saving lots of users from hitting problems, by 
keeping their arrays up and running, and giving their discs a chance to 
remap bad sectors, instead of forcing the user to do full-disc 
reconstructions more often which will make them more likely to hit read 
errors during recovery.

I do think we urgently need the hot reconstruction/recovery feature, so 
failing drives can be recovered to fresh drives with two sources of 
data, i.e. both the failing drive and the remaining drives in the array, 
giving us two chances of recovering every sector.

Cheers,

John.
