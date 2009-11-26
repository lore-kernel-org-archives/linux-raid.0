From: <senthilkumar.muthukalai@wipro.com>
Subject: RE: RAID 5 rebuild fails with power interruption.
Date: Thu, 26 Nov 2009 11:56:48 +0530
Message-ID: <8338BD137FF1B64EB341218BD702985E02B43F85@BLR-EC-MBX03.wipro.com>
References: <8338BD137FF1B64EB341218BD702985E02AB8FCF@BLR-EC-MBX03.wipro.com><87y6m759o2.fsf@frosties.localdomain><8338BD137FF1B64EB341218BD702985E02AB90B8@BLR-EC-MBX03.wipro.com><20091117094720.4c8736d7@notabene.brown><8338BD137FF1B64EB341218BD702985E02AB9233@BLR-EC-MBX03.wipro.com><20091118163655.2ef3f00d@notabene.brown><8338BD137FF1B64EB341218BD702985E02B43A2A@BLR-EC-MBX03.wipro.com><20091125131413.51a37b79@notabene.brown><8338BD137FF1B64EB341218BD702985E02B43EC7@BLR-EC-MBX03.wipro.com> <20091126075847.3a736e16@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20091126075847.3a736e16@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh sorry... That's a typo...
Its 2.16.8.
Anyways, thanks for the help.
Let me try to backport as you say.

Thanks,
Senthil M

-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Thursday, November 26, 2009 2:29 AM
To: SenthilKumar Muthukalai (WT01 - Telecom Equipment)
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID 5 rebuild fails with power interruption.

On Wed, 25 Nov 2009 19:50:47 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Neil,
> 
> The patch you have provided doesn't seem to go with the code we use.
> We use the md driver that comes with linux-1.16.8 source code.
> Could you pls suggest the changes for this version of md?

I have no idea what you mean by "linux-1.16.8".
My patch is against the latest main-line kernel with is 2.6.32-rc7 or
something close to that.  I only provide patches against mainline.
If you need it backported to an earlier kernel, that is up to you.

NeilBrown
