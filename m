From: Martin Wilck <mwilck@arcor.de>
Subject: Re: DDF / RAID10 patch series for mdadm
Date: Wed, 06 Mar 2013 19:26:09 +0100
Message-ID: <51378A41.8020606@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de> <20130304162254.3ce38218@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130304162254.3ce38218@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

> Wow! Thanks for these!  Happy to see DDF getting some attention.
> 
> I've applied all the patches (with a few minor cosmetic changes).  I haven't
> studied them all very closely, but I what I did examine looked good.
> 
> If you could add some tests to the 'tests' directory to make sure that
> ddf/raid10 keeps working that would be great.

Thanks a lot for applying. I'll have to study the test code to come up
with test cases. There'll be some work to be done for Create first (not
everyone has a BIOS RAID available for that).

I am currently working on a second patch series that deals with failures
and metadata updates.

Martin
