From: Phil Turmel <philip@turmel.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Mon, 12 Feb 2018 12:16:15 -0500
Message-ID: <6c416847-23d2-93c5-0512-c24751959eea@turmel.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <1934212.TzpEgCIeIR@matkor-lenovo>
 <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org>
 <3275011.qXpCPUrKDu@matkor-lenovo>
 <0780e95c-ae84-4b2b-0222-f59df368a2ee@turmel.org>
 <20180212164933.GA15015@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180212164933.GA15015@merlins.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/12/2018 11:49 AM, Marc MERLIN wrote:
> On Mon, Feb 12, 2018 at 10:29:20AM -0500, Phil Turmel wrote:
>>> Is there any option for mdadm --monitor to send warning e-mail when bbl entry 
>>> is added? (I can't see anything regarding bbl in mdadm --monitor section) ?
>>
>> No.  The feature is incomplete.  The only mitigation is to turn it off.
> 
> I had a quick look but didn't really find how to turn it off after the fact
> (not at array creation time, but after it's already been created).
> 
> Can you suggest how?

mdadm --assemble --update=no-bbl

There's another (undocumented?) option required when there are entries
in the list -- you'll have to dig that out for your situation.
