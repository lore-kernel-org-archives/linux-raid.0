From: Phil Turmel <philip@turmel.org>
Subject: Re: SMART, RAID and real world experience of failures.
Date: Mon, 09 Jan 2012 11:37:19 -0500
Message-ID: <4F0B17BF.3020507@turmel.org>
References: <4F063808.6040000@crc.id.au> <20230.55643.346235.891308@tree.ty.sabi.co.UK> <4F06DDAC.1050501@crc.id.au> <4F06F969.1010205@turmel.org> <20234.65226.464692.42166@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20234.65226.464692.42166@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/09/2012 09:50 AM, Peter Grandi wrote:
>>>> I got a SMART error email yesterday from my home server with a 4
>>>> x 1Tb RAID6. [ ... ]
> 
>>>> That's an (euphemism alert) imaginative setup. Why not a 4
>>>> drive RAID10? In general there are vanishingly few cases in
>>>> which RAID6 makes sense, and in the 4 drive case a RAID10
>>>> makes even more sense than usual. Especially with the really
>>>> cool setup options that MD RAID10 offers.
> 
>> In this case, the raid6 can suffer the loss of any two drives
>> and continue operating.  Raid10 cannot, unless you give up
>> more space for triple redundancy.
> 
> When I see arguments like this I am sometimes (euphemism alert)
> enthused by their (euphemism alert) profundity. A defense of a
> 4-drive RAID6 is a particularly compelling example, and this
> type of (euphemism alert) astute observation even more so.

<< plonk >>
