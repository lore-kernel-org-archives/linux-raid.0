From: Phil Turmel <philip@turmel.org>
Subject: Re: hung grow
Date: Tue, 10 Oct 2017 16:18:18 -0400
Message-ID: <4033a13e-3ea2-e32a-90a3-a5c86e24ed69@turmel.org>
References: <CADg2FGbgdgHWbaJN94p36-SUjfDEKNi2VYuyHXJN1pDJ9Kdg7w@mail.gmail.com>
 <CADg2FGaeuptaWRnM5+Z_aAR08vG-311s8p6OrBwZUNeCrNGu1g@mail.gmail.com>
 <87d15xymgc.fsf@notabene.neil.brown.name>
 <CADg2FGbzr_JcrGfvU6kpGc_5vJ=+L2gXx3PcfpOTsst8BeNA-Q@mail.gmail.com>
 <CADg2FGaFt4_4UHPUSnY8tr=LeJMKKojR_QrPE-YoXvWmgXXZxQ@mail.gmail.com>
 <0d4987d9-e8ff-0cdb-6e45-7f962b75c189@turmel.org>
 <3e5766b0-1437-2857-4806-264386d1633f@youngman.org.uk>
 <6d4b7055-c26c-951e-b63c-273a7fe447b8@turmel.org>
 <CADg2FGad+Tpu-4Z4rx1Kx_U1Tw64nQ_FqGuPRn5ODV=_pYFuDw@mail.gmail.com>
 <e8dce17e-d231-0004-e9a1-511abacfcfda@turmel.org>
 <CADg2FGZ-=VP2Q++qkKqfQ06zeBho1TR3=biqbdxT7-4pMCcLLQ@mail.gmail.com>
 <5a3fb3ec-299a-67c9-9d1c-ef28ca2164dd@turmel.org>
 <CADg2FGYQti9hFAqtRMEH8B-i4kwJJ3fYRdrRauD5F3OSZ_Q0vw@mail.gmail.com>
 <91ef85f8-4644-4918-1dbd-013e26050e4b@turmel.org>
 <CADg2FGZR-44hQ5fhy3QzByCWbfDUaXkQg2BismN0WztEOk6YnQ@mail.gmail.com>
 <CADg2FGZNRk_v4KRZ-6Qmvn3u9ByYLoHrBydjKY6rEw7pNZ0w5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADg2FGZNRk_v4KRZ-6Qmvn3u9ByYLoHrBydjKY6rEw7pNZ0w5A@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Curt <lightspd@gmail.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/2017 03:51 PM, Curt wrote:
>> I tried a mount, it just sits there.  No errors, which I'm not sure if
>> that's good or bad, so it's almost like it's just waiting for the
>> device to not be busy.  I noticed it was lists both a reshape and
>> spare rebuild.  Could it be it's trying to rebuild the spare and
>> getting in some kind of dead lock?
> 
> Follow up, here's the top process, does this look right to you?
> 9771 root      20   0       0      0      0 R 100.0  0.0  38:27.01 md127_raid6

No, that's not good. And blocking the mount process is a disaster.

Please take notes on all device serials vs. MD device # and consider
trying everything with rescue distro.  I generally use SystemRescueCD,
but anything with the latest stable kernel and mdadm might help.

Phil

