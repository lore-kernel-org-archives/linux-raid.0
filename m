Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADBFC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 19 Dec 2021 22:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhLSW67 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Dec 2021 17:58:59 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:42337 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232157AbhLSW66 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 19 Dec 2021 17:58:58 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mz1qh-0006Ze-Az; Sun, 19 Dec 2021 19:27:59 +0000
Message-ID: <25199865-b3a1-cf80-5780-b8e31a13b0a4@youngman.org.uk>
Date:   Sun, 19 Dec 2021 19:27:58 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Debugging system hangs
Content-Language: en-GB
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
 <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
 <cbfc2f45-96d8-4ee7-a12b-5a24bd2f2159@youngman.org.uk>
 <CAAMCDeemZO2u_4WW8pHVP2qOxz0HdHQTy2Gsa=zgY-7g4ptw7w@mail.gmail.com>
 <af7e8f4e-d770-5fde-f007-1894d62c15e6@youngman.org.uk>
 <CAAMCDecF2PoAtAb1w6reU=RYocaDPb0ZVQ20S44QOrh3fVEXNw@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CAAMCDecF2PoAtAb1w6reU=RYocaDPb0ZVQ20S44QOrh3fVEXNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/12/2021 18:46, Roger Heflin wrote:
> You will need to figure out on your distribution where messages get saved.
> 
> On Sun, Dec 19, 2021, 11:52 AM Wols Lists <antlists@youngman.org.uk 
> <mailto:antlists@youngman.org.uk>> wrote:
> 
>     On 15/12/2021 22:05, Roger Heflin wrote:
>      > There would be various messages.
>      >   grep -E 'ATA| sd |ata[0-9]' /var/log/messages
>      > might get you details.  It will also show when the disks are first
>      > showing up and being reported.
> 
>     thewolery /home/anthony # tail /var/log/messages
>     tail: cannot open '/var/log/messages' for reading: No such file or
>     directory
> 
I found it - journalctl. As luck would have it, the system hung, I think 
at 18:35


thewolery /home/anthony # journalctl --since=18:20:00
-- Journal begins at Mon 2021-06-21 14:57:58 BST, ends at Sun 2021-12-19 
19:21:36 GMT. --
Dec 19 18:29:05 thewolery dmeventd[1226]: dmeventd was idle for 3600 
second(s), exiting.
Dec 19 18:29:05 thewolery dmeventd[1226]: dmeventd shutting down.
Dec 19 18:32:55 thewolery plasmashell[1682]: libkcups: 
Create-Printer-Subscriptions last error: 1282 Bad file descriptor
Dec 19 18:32:55 thewolery plasmashell[1682]: libkcups: Request failed 
1282 -1
Dec 19 18:34:53 thewolery kded5[1655]: ktp-kded-module: "auto-away" 
presence change request: "away" ""
Dec 19 18:34:53 thewolery kded5[1655]: ktp-kded-module: plugin queue 
activation: "away" ""
Dec 19 18:34:53 thewolery kscreenlocker_greet[4420]: Qt: Session 
management error: networkIdsList argument is NULL
Dec 19 18:34:54 thewolery kded5[1655]: ktp-kded-module: 
"screen-saver-away" presence change request: "away" ""
Dec 19 18:34:54 thewolery kded5[1655]: ktp-kded-module: plugin queue 
activation: "away" ""
Dec 19 18:34:54 thewolery kscreenlocker_greet[4420]: 
file:///usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/components/UserList.qml:41:9: 
Unable to assign [undefined] to bool
Dec 19 18:34:54 thewolery kscreenlocker_greet[4420]: 
file:///usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/components/UserList.qml:41:9: 
Unable to assign [undefined] to bool
Dec 19 18:40:54 thewolery kded5[1655]: ktp-kded-module: "auto-away" 
state change: TelepathyKDEDModulePlugin::Enabled
Dec 19 18:40:54 thewolery kded5[1655]: ktp-kded-module: plugin queue 
activation: "away" ""
Dec 19 18:40:59 thewolery kwin_x11[1659]: qt.qpa.xcb: QXcbConnection: 
XCB error: 3 (BadWindow), sequence: 39263, resource id: 65011771, major 
code: 18 (ChangeProperty), minor code: 0
Dec 19 18:40:59 thewolery kded5[1655]: ktp-kded-module: 
"screen-saver-away" state change: TelepathyKDEDModulePlugin::Enabled
Dec 19 18:40:59 thewolery kded5[1655]: ktp-kded-module: plugin queue 
activation: "unset" ""

So that looks to me either it's not anything gets logged, or quite 
likely it was so abrupt the system never got a chance to log it ...

So it looks like netconsole is it ...

And today I discovered that the shop that messed up fixing my computer 
has messed up even further - I've lost the cpu cooler fixing bars ... it 
might not be them but it wouldn't surprise me ... :-( so that's another 
one ordered from Amazon ...

Cheers,
Wol
