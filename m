From: Phil Turmel <philip@turmel.org>
Subject: Re: Cannot start array on disk
Date: Fri, 22 Jul 2016 10:48:47 -0400
Message-ID: <48687c4e-792c-7cdc-7374-3020964f1892@turmel.org>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com>
 <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com>
 <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org>
 <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com>
 <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com>
 <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org>
 <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bhatia Amit <amitbhatia@rocketmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/20/2016 10:00 PM, Bhatia Amit wrote:
> 
> 
>> I'm not sure if this is supported, by try specifying the version along
>> with --examine for each of v0.90, v1.0, v1.1, and v1.2 to see if any
>> difference shows.  Paste the results from each.
> 
> 
> Hi Phil
> 
> Only metadata v1.0 seems to be valid for sdc4.

Hmm.  I'm stumped.  The only thing left that I'd try is to hexdump
search the partition looking for an ext4 magic signature.  That would
give us a clue.

{ Fair warning: this doesn't often end well. }

To find possible ext4 signatures, use this:

hexdump -C /dev/sdc4 |egrep '^[0-9a-f]+30  .+  53 ef' >sb.lst

Not all of them will be superblocks, of course, but that will give
addresses that can be more closely examined.  Paste the first hundred or
so matches in your reply.

Phil
