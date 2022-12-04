Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65818C352A1
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 02:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiLDCrQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 21:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiLDCrO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 21:47:14 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CA21D0EB
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 18:47:13 -0800 (PST)
Received: from [73.207.192.158] (port=35540 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1f28-0008Rt-T5
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 20:47:12 -0600
Date:   Sun, 4 Dec 2022 02:47:11 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: batches and serial numbers
Message-ID: <20221204024711.GE19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo>
 <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
 <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
 <20221203180425.GU19721@jpo>
 <38fdcd1b-2122-1f06-8dfe-5b2f8ffa8670@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <38fdcd1b-2122-1f06-8dfe-5b2f8ffa8670@youngman.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol --

...and then Wols Lists said...
% On 03/12/2022 18:04, David T-G wrote:
% > % It's why my raid is composed of a Seagate Barracuda 3TB (slap wrist, don't
% > % use Barracudas!), 2 x 4TB Seagate Ironwolves, and 1 Toshiba 8TB N300.
% > 
% > These are Tosh X300s, FWIW.  Like 'em so far!
% 
% OUCH !!!
% 
% https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

No, I'm familiar.


% 
% Do the X300s have ERC, and what's the timeout? Barracudas are nice drives, I

Yep and good.

  diskfarm:~ # /usr/local/bin/smartctl-disks-timeout.sh 
  Drive timeouts: sda Y ; sdb Y ; sdc Y ; sdd Y ; sde Y ; sdf 180 ; sdg 180 ; sdh Y ; sdi 180 ; sdj Y ; sdk Y ; sdl 180 ; sdm Y ; 

I'll append my little enhancement of your script after my sig in case you
find the tweaks interesting.


% like 'em, but they're not good in raid. And the BarraCudas even less so!
% I've got a nasty feeling your X300s are the same!

They have been good to me so far.  I was originally going to get N300s,
but I couldn't at the time, and the X300s read as the same for everything
I could find.  Does your N300 have ERC with a short timeout enabled by
default?


% 
% I said it's easy to get slices kicked out due to misconfiguration - that's
% exactly what happens with Barracudas, and I suspect your X300s suffer the
% exact same problem ...

Well, perhaps.  I'd love to have been able to pin it down, but I never
saw any errors and, perhaps because it was too late by then, couldn't
track them down with additional help from folks here.


% 
% Read up, and come back if you've got any problems. The fix is that script,
% but it means if anything goes wrong you're going to be cursing "that damn
% slow computer".

*grin*


% 
% Cheers,
% Wol


Thanks again & HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

######################################################################

#!/bin/sh

# set timeouts manually where needed

CRED='[31m'
CYLO='[33m'
CGRN='[32m'
CBLU='[34m'
CBLK='[0m'

# set the timeouts on the local drives
printf "${CBLU}Drive timeouts${CBLK}: "
for DISK in sda sdb sdc sdd sde sdf sdg sdh	# a-d on mobo ; e-h on card
# do i want to apply this to USB drives that show up? hmmm...
do
  printf "$DISK "
  smartctl -q errorsonly -l scterc,70,70 /dev/$DISK
  if [ 4 -eq $? ]
  then
    echo 180 > /sys/block/$DISK/device/timeout
    printf "${CYLO}180"
  else
    printf "${CGRN}Y"
  fi
  printf "${CBLK} ; "
done
echo ''

