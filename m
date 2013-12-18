From: Phil Turmel <philip@turmel.org>
Subject: Re: Is it possible to create a raid from/over other raids?
Date: Wed, 18 Dec 2013 18:32:12 -0500
Message-ID: <52B2307C.3070909@turmel.org>
References: <BLU0-SMTP2702D8075688EF7D229D66498DA0@phx.gbl> <52B2238C.4000605@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52B2238C.4000605@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/18/2013 05:37 PM, Adam Goryachev wrote:

[trim /]

> BTW, can anyone comment whether this would work:
> Using linear, then only the portion of the RAID0 with the failed disk
> will be failed in the RAID6, so 2/3rds will still be 4 disk RAID6 and
> 1/3rd will be 3 disk RAID6?

No, the entire linear array will be kicked out from under the raid6.  As
you said yourself, "MD uses block devices, and produces block devices".
 It doesn't look "under the hood" of an array's components.

Phil

