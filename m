From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 14:37:00 +0100
Message-ID: <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <d21f169e-0546-aa00-ce19-b6688ba74da6@turmel.org>
 <CADg2FGbnMzLBqWthKY5Uo__ANC2kAqH_8B1G23nhW+7hWJ=KeA@mail.gmail.com>
 <CADg2FGYc-sPjwukuhonoUUCr3ze3PQWv8gtZPnUT=E4CvsQftg@mail.gmail.com>
 <7e23d39b-aebb-0852-c98f-758bd99d3eb9@turmel.org>
 <CADg2FGZatpLPHbuJUEuitbipfX77T1XXduEpLTQjPzq2e56fgg@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org>
 <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <87po9xyv0r.fsf@notabene.neil.brown.name>
 <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name>
 <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Curt <lightspd@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/17 14:06, Phil Turmel wrote:
> On 10/10/2017 08:08 AM, Curt wrote:
>> On Mon, Oct 9, 2017 at 8:41 AM, Curt <lightspd@gmail.com> wrote:
>>> On Mon, Oct 9, 2017 at 12:28 AM, NeilBrown <neilb@suse.com> wrote:
>>>> What happens if you run the --assemble --update=revert-reshape command on
>>>> these 6 devices (without --force)??
>>>
>>> Here's the output
>>> mdadm --assemble --verbose --update=revert-reshape /dev/md127
>>> /dev/sda1 /dev/sdc1 /dev/sdd1 /dev/sdb /dev/sdg1 /dev/sdz1
>>> mdadm: looking for devices for /dev/md127
>>> mdadm: Reshape position is not suitably aligned.
>>> mdadm: Try normal assembly and stop again
>>>
>>
>> What are the steps I need to take to resume the grow, but just enough
>> to get it to the point I can revert it and see what data I have on the
>> drives? Or can I force the revert?
> 
> I'm stumped.  Since your reshape position, while "0%", was 4GB into your
> array, there's no way to use --create --assume-clean to fix this.
> 
> Unless Neil knows some magic, your data is toast.  Sorry.
> 
I guess the only chance is to try and get all the drives that were 
reshaping (or copies of them) in a fit state to try and re-assemble the 
array. Would the revert work then? Or would the reshape crash on hitting 
the first bad sector?

Cheers,
Wol
