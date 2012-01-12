From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Thu, 12 Jan 2012 10:24:51 +0100
Message-ID: <4F0EA6E3.8010705@redhat.com>
References: <1325762201-23949-1-git-send-email-Jes.Sorensen@redhat.com>	<1325762201-23949-2-git-send-email-Jes.Sorensen@redhat.com> <20120112104320.471910db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120112104320.471910db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

On 01/12/12 00:43, NeilBrown wrote:
> Applied - thanks...
> 
> Do you understand this stuff?  If this really "fixing" anything, or is it
> still doing something bad, but is now hiding it from gcc's warning so we just
> don't get told how naughty we are?
> 
> Should these things be changed to use unions ??

I have to admit that I didn't want to touch the functionality. It was
basically the sha code which is sensitive to changes, and I don't
understand the algorithm, and the ddf metadata which I have no way of
testing, so I opted for functionality rather than risking breaking
someone's data.

Cheers,
Jes
