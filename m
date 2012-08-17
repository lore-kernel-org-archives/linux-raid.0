From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Fri, 17 Aug 2012 03:29:37 -0500
Message-ID: <502E00F1.8090207@hardwarefreak.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <CAEyJA_sfAUk9PNFfss9m=pAi90Pb0gTHo9seV-BDexr3pLVvxg@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_sfAUk9PNFfss9m=pAi90Pb0gTHo9seV-BDexr3pLVvxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/16/2012 5:11 PM, vincent Ferrer wrote:
> On Wed, Aug 15, 2012 at 10:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 8/15/2012 9:56 PM, vincent Ferrer wrote:
>>
>>> - My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
>>> - I created  a raid5 device of  10  SSDs .
>>
>> No it is not normal practice.  I 'preach' against it regularly when I
>> see OPs doing it.  It's quite insane.
>>
>> There are a couple of sane things you can do today to address your problem:
>>
>> Stan
>>
> 
> Hi Stan,
> Follow-up question for  2  types of setups i may have to prepare:
> 1) setup A   has   80   SSDs.    

This is simply silly.  There's no need for exaggeration here.

>  2) Setup B  has only 12 SSDs.  Question:  Is it more practical to
> have only one raid5  device,  even though I may have 4-5  physically
> different  clients or create 2 raid5 devices each having  6 SSDs.

As I repeat in every such case:  What is your workload?  Creating a
storage specification is driven by the requirements of the workload.

-- 
Stan
