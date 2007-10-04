From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: RAID 5 performance issue.
Date: Thu, 04 Oct 2007 12:46:05 -0400
Message-ID: <470518CD.10405@maine.edu>
References: <20071003105321.06943824@zeus.pccl.info>	<Pine.LNX.4.64.0710031243080.8612@p34.internal.lan>	<20071003211910.439ded54@alpha.digital-domain.net>	<72dbd3150710031336s331782c3yd0ac7ceda4e81774@mail.gmail.com>	<20071004150831.6edbf926@zeus.pccl.info>	<Pine.LNX.4.64.0710041009150.8275@p34.internal.lan>	<20071004153656.16e10f9e@zeus.pccl.info>	<Pine.LNX.4.64.0710041038400.8275@p34.internal.lan> <20071004160316.5332a370@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071004160316.5332a370@zeus.pccl.info>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Clayton <andrew@digital-domain.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Rees <drees76@gmail.com>, Andrew Clayton <andrew@pccl.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Clayton wrote:
> On Thu, 4 Oct 2007 10:39:09 -0400 (EDT), Justin Piszcz wrote:
>
>
>   
>> What type (make/model) of the drives?
>>     
>
> The drives are 250GB  Hitachi Deskstar 7K250 series ATA-6 UDMA/100
>   

A couple of things:

    1. I thought you had SATA drives
    2. ATA-6 would be UDMA/133

The SATA-1 versions of the 7K250's did not have NCQ. The SATA-2 versions 
do have NCQ. If you do have SATA drives, are they SATA-1 or SATA-2?

Steve
