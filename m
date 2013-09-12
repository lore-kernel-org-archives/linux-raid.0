From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH] mdmon: honour --offroot, again
Date: Thu, 12 Sep 2013 20:25:46 +0200
Message-ID: <5232072A.5050308@arcor.de>
References: <1378930519-7679-1-git-send-email-mwilck@arcor.de> <20130912154250.09c986c2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130912154250.09c986c2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/12/2013 07:42 AM, NeilBrown wrote:
> On Wed, 11 Sep 2013 22:15:19 +0200 mwilck@arcor.de wrote:
> 
>> Reintroducing --offroot as an undocumented option, as its use is going to
>> go away soon anyway.
>>
> 
> Aggh...  This is all pretty horrible isn't it?
> 
> I've applied your patch because I don't think it can break anything and it
> could possible help as you say.

I just verified that OpenSUSE Factory still needs this patch as well.
Fedora is probably the only distribution that "properly" (according to
the systemd developers) starts and stops mdmon from "offroot" (i.e. initrd).

Martin
