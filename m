From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 raid5d  multi-thread
Date: Fri, 01 Nov 2013 11:19:50 -0500
Message-ID: <5273D4A6.3070308@hardwarefreak.com>
References: <72a920d2-2c76-41af-bcac-0dee5b36df5a@aliyun.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72a920d2-2c76-41af-bcac-0dee5b36df5a@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/31/2013 10:27 PM, lilofile wrote:
> now in MD raid5,stripe is hande in one thread, and I found the CPU occupation is very high, why stripe is not handled in multi-thread ? is any different to implement? and what consideration in original design?

Shaohua Li has been working on a threaded RAID5 implementation for many
months now.  AFAIK it is not yet ready for inclusion nor widespread
testing by others.  See:

https://lkml.org/lkml/2013/7/30/29

-- 
Stan
