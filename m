From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 15:12:44 +0100
Message-ID: <6b819e9e-94c7-cb37-af5a-9b0a0070f62b@youngman.org.uk>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
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
 <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Curt <lightspd@gmail.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/17 15:00, Phil Turmel wrote:
> On 10/10/2017 09:37 AM, Anthony Youngman wrote:
>> On 10/10/17 14:06, Phil Turmel wrote:
>>> On 10/10/2017 08:08 AM, Curt wrote:
>>>> On Mon, Oct 9, 2017 at 8:41 AM, Curt <lightspd@gmail.com> wrote:
> 
>>>>> mdadm: Reshape position is not suitably aligned.
> 
> I've never seen this before, and don't have time at the moment
> to read the code to understand what it means.

My reaction (having read the thread :-) is that one of the drives being 
used to try to re-assemble the array was dd'd from a drive that failed 
before the reshape. So that was "one of 7, no reshape". All of the 
others were "one of 9, reshape in progress, same position". So if we can 
get the drives that were reshaping, we should be able to revert it. 
Question is, can we?
> 
>>> Unless Neil knows some magic, your data is toast.  Sorry.
> 
>> I guess the only chance is to try and get all the drives that were
>> reshaping (or copies of them) in a fit state to try and re-assemble the
>> array. Would the revert work then?
> 
> Probably.  But yeah, "fit state".  That's the magic. /-:

So if Curt can do it, I think we stand a chance. A chance.
> 
>> Or would the reshape crash on hitting
>> the first bad sector?
> 
> The two devices with pending sectors have been ddrescue'd, so no.
> 
We'll just have a few bits of corruption, but then we knew that. Three 
drives gone from a raid-6, and any successful recovery is going to have 
*some* damage.

Cheers,
Wol
