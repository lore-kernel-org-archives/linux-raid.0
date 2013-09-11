From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Wed, 11 Sep 2013 21:55:26 +0200
Message-ID: <5230CAAE.1020804@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>	<20130909111546.2e9551b1@notabene.brown>	<522E13EF.3080001@arcor.de> <20130910100151.31048cad@notabene.brown> <5230C98B.7030902@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230C98B.7030902@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/11/2013 09:50 PM, Martin Wilck wrote:

> That means that libstorage's way of parsing mdadm -Es output must be
> changed, but that should be possible. Sending new patches.

Forgot to mention: It seems that IMSM BIOS forces users to set an array
name. LSI BIOS does not, the name is optional there. It is possible to
have several subarrays, each without name.

Martin

