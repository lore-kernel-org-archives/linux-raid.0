From: Curt <lightspd@gmail.com>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 17:23:40 -0400
Message-ID: <CADg2FGbJHbPaPeBdetTGuC-S2e17BWHOchEeiBjevibjH0pHGg@mail.gmail.com>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <89992d1f-172f-9fc6-3a1e-50df34e11d3b@turmel.org> <CADg2FGaPFTNLuQPussL=YFDCRndRDFX99D-KjnWfD93MqGJXmg@mail.gmail.com>
 <CADg2FGZNs9KmkKGvbCf-dwsqxYN5ftJd5v7RTJ1M=rLP=v6wJg@mail.gmail.com>
 <CADg2FGa5iUGVqVvy5MrJf00fCqH4NEVXrODPHS6Dc=jsrBx2PQ@mail.gmail.com>
 <87po9xyv0r.fsf@notabene.neil.brown.name> <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name> <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org> <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org> <CADg2FGad+Tpu-4Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com>
 <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org> <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com>
 <CADg2FGYQti9hFAqtRMEH8B-i4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com>
 <874lr6ybll.fsf@notabene.neil.brown.name> <CADg2FGbjqzFvrptLkM9LGYABZWDcmQC_rqEceo44yzADGhFGzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGbjqzFvrptLkM9LGYABZWDcmQC_rqEceo44yzADGhFGzw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Phil Turmel <philip@turmel.org>, Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 10, 2017 at 4:58 PM, Curt <lightspd@gmail.com> wrote:

>> Can you please
>>   mkdir /tmp/dump
>>   mdadm --dump=/dev/dump /dev...list.all.devices.in.the.array
>>   tar czf --sparse /tmp/dump.tgz /tmp/dump
>>
>  Yeah, I will get that for you once I reboot the server.
>
Quick question.  Is that supposed to be mdadm --dump=/dev/dump or /tmp/dump?
