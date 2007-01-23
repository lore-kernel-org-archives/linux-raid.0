From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Kernel 2.6.19.2 New RAID 5 Bug (oops when writing Samba -> RAID5)
Date: Tue, 23 Jan 2007 14:08:26 +0300
Message-ID: <45B5ECAA.6000100@tls.msk.ru>
References: <Pine.LNX.4.64.0701200718290.29223@p34.internal.lan> <45B5261B.1050104@redhat.com> <17845.13256.284461.992275@notabene.brown> <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701230556050.8978@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
[]
> Is this a bug that can or will be fixed or should I disable pre-emption on 
> critical and/or server machines?

Disabling pre-emption on critical and/or server machines seems to be a good
idea in the first place.  IMHO anyway.. ;)

/mjt
