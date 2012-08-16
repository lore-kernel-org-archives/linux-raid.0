From: vincent Ferrer <vincentchicago1@gmail.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 15:11:28 -0700
Message-ID: <CAEyJA_sfAUk9PNFfss9m=pAi90Pb0gTHo9seV-BDexr3pLVvxg@mail.gmail.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
	<502C8C18.5070501@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502C8C18.5070501@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 15, 2012 at 10:58 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/15/2012 9:56 PM, vincent Ferrer wrote:
>
>> - My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
>> - I created  a raid5 device of  10  SSDs .
>
> No it is not normal practice.  I 'preach' against it regularly when I
> see OPs doing it.  It's quite insane.
>
> There are a couple of sane things you can do today to address your problem:
>
> Stan
>

Hi Stan,
Follow-up question for  2  types of setups i may have to prepare:
1) setup A   has   80   SSDs.    Question: Should I still  create one
raid5 device or should I create  8  raid5 device each having 10 SSDs ?
    My linux based storage server may be accessed by  upto   10-20
physically  different clients.

 2) Setup B  has only 12 SSDs.  Question:  Is it more practical to
have only one raid5  device,  even though I may have 4-5  physically
different  clients or create 2 raid5 devices each having  6 SSDs.

Reason I am asking because I have seen enterprise storage arrays from
EMC/IBM where new raid5 device is created on demand  and (storage
firmware may spread across automatically across all the available
drives/spindles or can be intelligently selected by storage admin by
analyzing  workload to avoid  hot-spots)

Partitioning was only done because I am still waiting  budget approval
to buy SSDs.

regards
vincy
