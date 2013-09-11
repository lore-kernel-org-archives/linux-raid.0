From: Martin Wilck <mwilck@arcor.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Wed, 11 Sep 2013 21:50:35 +0200
Message-ID: <5230C98B.7030902@arcor.de>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>	<20130909111546.2e9551b1@notabene.brown>	<522E13EF.3080001@arcor.de> <20130910100151.31048cad@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130910100151.31048cad@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/10/2013 02:01 AM, NeilBrown wrote:

>> Well, yast is actually not calling --brief. It calls "mdadm --examine
>> --scan", and --scan implies --brief (comment in mdadm.c). My patch
>> simply causes DDF and IMSM to print similar output with "mdadm -Es".
>> Isn't that reasonable?
> 
> This bit that I really didn't like is where you synthesised a "ddf_%d" name
> if the name field was empty.  This is wrong.

Didn't really like it myself. Thanks for pointing it out.

> There are a couple of other places where the name is extracted from the
> ddf metadata: getinfo_super_ddf_bvd and container_content_ddf.
> If brief_examine_subarrays_ddf uses the name in the same way following
> the same rules (e.g. discarding trailing spaces) then that would be OK.
> But if the name is empty, then no name should be given in the 'array' line.

That means that libstorage's way of parsing mdadm -Es output must be
changed, but that should be possible. Sending new patches.

Martin
