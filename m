From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 09 Oct 2007 08:26:35 +1300
Message-ID: <470A846B.9090805@sauce.co.nz>
References: <20071008211313.6cd8bbb5@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071008211313.6cd8bbb5@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:

> Is it possible anyhow to create a "very degraded" raid array - a one
> that consists of 4 drives, but has only TWO ?

No, but you can make a degraded 3 drive array, containing 2 drives and 
then add the next drive to complete it.

The array can then be grown (man mdadm, GROW section), to add the fourth.

Regards,

Richard
