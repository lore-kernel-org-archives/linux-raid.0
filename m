From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10 failure(s)
Date: Tue, 15 Feb 2011 11:57:44 +1100
Message-ID: <20110215115744.3dd078b0@notabene.brown>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com>
	<AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
	<20110215094802.44d99c58@notabene.brown>
	<AANLkTimk-Z2EqaOFM87zgQEvBPE6H0wS9_acp83Gc4+5@mail.gmail.com>
	<20110215102007.0851f3b8@notabene.brown>
	<AANLkTi=5+2WJzg4=7cdWx-1+vUwyLcyHxKishCtX_nOH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=5+2WJzg4=7cdWx-1+vUwyLcyHxKishCtX_nOH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <grimm26@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 18:49:03 -0600 Mark Keisler <grimm26@gmail.com> wrote:

> Oh, duh, was thinking in 0+1 instead of 10.  I'm still wondering why
> you made mention of "but be really sure that the devices really are
> working before you try this."  If trying to bring the RAID back fails,
> I'm just back to not having access to the data which is where I am now
> :).

If you try reconstructing the array before you are sure you have resolved the
original problem (be it BIOS setting, bad cables, dodgey controller or even a
bad disk drive) then you risk compounding your problems and at least are
likely to waste time.
Sometimes people are in such a hurry to get access to their data that they
cut corners to their detriment.  I don't know if you are such a person, but
I mentioned it anyway just in case.

NeilBrown

