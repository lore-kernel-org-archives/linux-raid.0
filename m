From: "NeilBrown" <neilb@suse.de>
Subject: Re: Reliability of bitmapped resync
Date: Tue, 24 Feb 2009 08:49:08 +1100 (EST)
Message-ID: <16ff0082259ce384e30c4a7f9a0e66fb.squirrel@neil.brown.name>
References: <20090223194019.GA3488@lazy.lzy>
    <b2460d0414270e6a6be4c91ec2d5a071.squirrel@neil.brown.name>
    <20090223201905.GA7585@lazy.lzy>
    <e3d195aab8b8de113e146e2932996777.squirrel@neil.brown.name>
    <20090223214016.GB18555@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090223214016.GB18555@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, February 24, 2009 8:40 am, Piergiorgio Sartor wrote:
> Hi,
>
>> I might have found something.  If the bitmap chunk size is smaller than
>> the raid10 chunk size, and the first bitmap chunk in a raid10 chunk is
>> clean, it might be skipping the remaining bitmap chunks in that
>> raid10 chunk.
>
> the RAID-10 chunk is standard 64K, the bitmap
> chunk should be 256K.
> So, this does not seem to be the case, if I
> got it correctly.

OK.. In that case I cannot reproduce the problem.


>
>> Can you please show me "--examine" and "--examine-bitmap" of one of the
>> devices in your array please.
>
> OK, but you'll have to wait until tomorrow, I do
> not have the PC here (it is an office PC).

I'll wait for these details before I start hunting further.

Thanks,
NeilBrown

