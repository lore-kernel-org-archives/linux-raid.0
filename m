From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: RAID 5 rebuild fails with power interruption.
Date: Thu, 26 Nov 2009 17:24:27 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02B4408E@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com> <20091126075847.3a736e16@notabene.brown> <8338BD137FF1B64EB341218BD702985E02B43F85@BLR-EC-MBX03.wipro.com> <200911260448.55466.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <200911260448.55466.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh no... again a typo?!
Anyways thanks for notifying that...

-----Original Message-----
From: Thomas Fjellstrom [mailto:tfjellstrom@shaw.ca] 
Sent: Thursday, November 26, 2009 5:19 PM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Subject: Re: RAID 5 rebuild fails with power interruption.

On Wed November 25 2009, you wrote:
> Oh sorry... That's a typo...
> Its 2.16.8.

That kernel still doesn't exist ;)

the largest numbered kernel out now is 2.6.31, with 2.6.32 coming out
soon. 
Maybe you meant 2.6.18? That's pretty old, if you can upgrade you
probably 
should.

> Anyways, thanks for the help.
> Let me try to backport as you say.
> 
> Thanks,
> Senthil M
> 
> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Thursday, November 26, 2009 2:29 AM
> To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID 5 rebuild fails with power interruption.
> 
> On Wed, 25 Nov 2009 19:50:47 +0530
> 
> <senthilkumar.muthukalai@wipro.com> wrote:
> > Neil,
> >
> > The patch you have provided doesn't seem to go with the code we use.
> > We use the md driver that comes with linux-1.16.8 source code.
> > Could you pls suggest the changes for this version of md?
> 
> I have no idea what you mean by "linux-1.16.8".
> My patch is against the latest main-line kernel with is 2.6.32-rc7 or
> something close to that.  I only provide patches against mainline.
> If you need it backported to an earlier kernel, that is up to you.
> 
> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
