From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Raid-0 speed
Date: Thu, 26 Aug 2004 08:36:09 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412D68B9.2080304@wasp.net.au>
References: <412C1E23.1070104@wasp.net.au> <20040825211158.1242221a@vovapc.kpml.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040825211158.1242221a@vovapc.kpml.int>
To: "Vladimir I. Umnov" <uvi@ezmail.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vladimir I. Umnov wrote:
>>Also, doing a dd from 4 drives maxes out my read speed as per mdstat
>>at 160MB/s (How? PCI is 133MB/s and according to lspci all my
>>controllers are on the same bus). Does vmstat lie?
> 
> NO! PCI 2.3 can about 512 MB/s

Ok then. Umm so for a 32 bit bus at 33Mhz I'm maxing out my PCI bandwidth.
An Asus A7V600 motherboard does not do PCI 2.3

