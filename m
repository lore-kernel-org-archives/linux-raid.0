From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
 	of device.
Date: Wed, 05 Aug 2009 21:35:41 -0700
Message-ID: <4A7A5D9D.7030305@zytor.com>
References: <20090802215444.4198.83094.stgit@notabene.brown>	<20090802215818.4198.77041.stgit@notabene.brown>	<4A7A0287.5010505@zytor.com>	<170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>	<4A7A2EA6.9020603@zytor.com> <19066.19060.95471.616532@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752309AbZHFEfs@vger.kernel.org>
In-Reply-To: <19066.19060.95471.616532@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 08/05/2009 08:13 PM, Neil Brown wrote:

> 
> Thanks for the reports guys.
> 
> I managed to reproduce the lockup and I think this patch should fix
> it.
> If you could review/test I would appreciate it.
> 
> Thanks,
> NeilBrown
> 

This patch makes my system boot, whereas previously it would deadlock
100% of the time.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
