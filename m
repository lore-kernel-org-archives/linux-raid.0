From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 2/2] DDF: new algorithm for subarray UUID
Date: Sat, 07 Sep 2013 21:23:22 +0200
Message-ID: <522B7D2A.4000409@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de> <1378502781-849-2-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1378502781-849-2-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

On 09/06/2013 11:26 PM, mwilck@arcor.de wrote:
> Some fake RAID BIOSes (in particular, LSI ones) change the
> VD GUID at every boot. These GUIDs are not suitable for
> identifying an array. Luckily the header GUID appears to
> remain constant.
> 
> We construct a pseudo-UUID from the header GUID and those
> properties of the subarray that we expect to remain constant.

Thinking about it once more, it may actually be better to construct the
subarray UUID only from the container GUID and the member number (and
name), because if we implement Grow or Reshape for DDF, the other
properties might change.

I'm open for comments and suggestions.

Martin
