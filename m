From: Tim Small <tim@seoss.co.uk>
Subject: Re: 3-way mirrors
Date: Wed, 08 Sep 2010 10:06:11 +0100
Message-ID: <4C875203.2050203@seoss.co.uk>
References: <20100908061616.31334.qmail@s217.sureserver.com> <20100908164038.3067cc6f@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908164038.3067cc6f@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Michael Sallaway <michael@sallaway.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/09/10 07:40, Neil Brown wrote:
> It looks like you have an ancient kernel - older than April 2010 :-)
> A patch went in to 2.6.35 and I think some 2.6.34.y which fixed a bug that
> causes md to drop devices in a degraded RAID6 when it could have fixed the
> read error.  Commit 7b0bb5368a719
>
> So a newer kernel might fix your problem for you.
>    

FYI, at least Debian 5, and RHEL 5 have picked up these patches AFAIK.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

