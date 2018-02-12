From: Phil Turmel <philip@turmel.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Mon, 12 Feb 2018 10:29:20 -0500
Message-ID: <0780e95c-ae84-4b2b-0222-f59df368a2ee@turmel.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <1934212.TzpEgCIeIR@matkor-lenovo>
 <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org>
 <3275011.qXpCPUrKDu@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3275011.qXpCPUrKDu@matkor-lenovo>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Marc MERLIN <marc@merlins.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/12/2018 05:43 AM, Mateusz Korniak wrote:
> On Sunday 11 of February 2018 12:13:45 Phil Turmel wrote:
>> On 02/10/2018 04:43 PM, Mateusz Korniak wrote:
>>
>>> data is saved under different location when such write fails for
>>> later reads?
>>
>> No. (...)
> 
> So having arrays having non-empty BBL members means that array is in fact 
> degraded (for tiny part, but still), right?

Yes, it's degraded wherever there's a BBL entry.  To my knowledge, *no*
upper layer, whether device mapper or any filesystem, uses the
information to avoid allocations in the degraded area or to rescue the
data precariously living there.  Last I looked, mdadm --detail did not
report whether the array has degraded regions.  You must inspect the
output of mdadm --examine for every member.

> Is there any option for mdadm --monitor to send warning e-mail when bbl entry 
> is added? (I can't see anything regarding bbl in mdadm --monitor section) ?

No.  The feature is incomplete.  The only mitigation is to turn it off.

Phil
