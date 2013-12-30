From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Doesn't "writes" do what resync does ?
Date: Mon, 30 Dec 2013 21:36:02 +1300
Message-ID: <52C13072.2060303@insync.za.net>
References: <52C0AD5A.1040802@insync.za.net> <52C11FDF.1040307@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C11FDF.1040307@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/12/2013 20:25, Stan Hoeppner wrote:
> On 12/29/2013 5:16 PM, Pieter De Wit wrote:
>> <snip>
>> Should that resync not have had more completed ?
> Your question is invalid.  What you meant to ask is
>
> "Why are pvdisplay and mdstat reporting what seems to be conflicting
> state data?"
>
> Did you also ask on the lvm list why pvdisplay says most PEs are
> consumed, yet mdstat says resync is only 17% complete?
>
Hi again Stan,

pvdisplay says most PEs are consumed because I moved that data to the 
device. My question, rephased then:

Shouldn't writes to a RAID device count as resyncs ?

Cheers,

Pieter
