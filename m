From: Phil Turmel <philip@turmel.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Sun, 11 Feb 2018 12:13:45 -0500
Message-ID: <fae4eb2a-59dc-9788-31ff-2b90d24328b9@turmel.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <1934212.TzpEgCIeIR@matkor-lenovo>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1934212.TzpEgCIeIR@matkor-lenovo>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Marc MERLIN <marc@merlins.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/10/2018 04:43 PM, Mateusz Korniak wrote:
> On Friday 09 of February 2018 15:13:26 Phil Turmel wrote:
>> If you have bad block lists enabled in your array, MD will *never* try
>> to fix the underlying sectors
> 
> As far I was able to find, failed write marks sector in BBL. 
> Does data is saved under different location when such write fails for later 
> reads?

No.  That is why this is a misfeature that should never have been turned
on by default.

Phil
