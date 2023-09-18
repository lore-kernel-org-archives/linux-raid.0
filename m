Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89FAEC46CA1
	for <linux-raid@archiver.kernel.org>; Mon, 18 Sep 2023 17:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbjIRRHK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Sep 2023 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjIRRHJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Sep 2023 13:07:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860D1AD
        for <linux-raid@vger.kernel.org>; Mon, 18 Sep 2023 10:07:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED84C433C9
        for <linux-raid@vger.kernel.org>; Mon, 18 Sep 2023 17:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695056820;
        bh=tq81aizpw12bI3WqjM9ysYmYpZTc41RGEzF+jhlhOIE=;
        h=From:Date:Subject:To:Cc:From;
        b=iL38DMxMID1XVRTDO7bBr8aj8cHbD2E403Xv/X+6LxpTxJeGX6oDYhpIOAqvbHYzh
         khvlvd4QL7Lk/yU+nxuea5S2RfWs2jkbgNOaeWQPxo8YtAv3/eWwQy8OwL8NF+4s12
         rlNfNlmppd5CyuckxNR1NC1GD48pZ0cM9iyun7W6Sd6q5QGHrWr5lx68I57Ni4Ejn5
         9HRCzED2QdA+NHV/H6Pzo/UC5zMCQIeZEh+31IjscSpa3fgA8y1zMDPqLp/HLjDhtp
         0VnlHHb0Sqb16zbN9M1QGG4Qd2nzHJ4XP5vP5h4D3MfphtkdLbmlcMYeadaqosDz0K
         5Wh42UJl7lhBg==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50325ce89e9so778878e87.0
        for <linux-raid@vger.kernel.org>; Mon, 18 Sep 2023 10:07:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YwcGVcizl3FmL6DGWJ1wcSegydmdtdVja/9qgmPuzgI+S1VBcLf
        wS6kofU4n3IjRYuFl4bTKJyls6C7xuZvJFAP6QU=
X-Google-Smtp-Source: AGHT+IH4qFKsbI/KWD9tE/X30ov4TZ9DS3up6MKeSvteHPf61KatQDe/m1gcLBBpMfS5EF/15miGKBBTzJBLP/aFUVc=
X-Received: by 2002:ac2:5e67:0:b0:501:c17c:fdae with SMTP id
 a7-20020ac25e67000000b00501c17cfdaemr7210870lfr.31.1695056818281; Mon, 18 Sep
 2023 10:06:58 -0700 (PDT)
MIME-Version: 1.0
From:   Song Liu <song@kernel.org>
Date:   Mon, 18 Sep 2023 10:06:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7yHE6HwsGfLBxqpvDh53g9deD9Y9SH58HVU5HCLqLefg@mail.gmail.com>
Message-ID: <CAPhsuW7yHE6HwsGfLBxqpvDh53g9deD9Y9SH58HVU5HCLqLefg@mail.gmail.com>
Subject: Slack workspace for md/raid collaboration
To:     linux-raid <linux-raid@vger.kernel.org>
Cc:     "Luse, Paul E" <paul.e.luse@intel.com>,
        Jes Sorensen <jes@trained-monkey.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi folks,

We have created a Slack workspace to coordinate work in the md/raid space.
The workspace is primarily used by developers to discuss issues and plans.
Please use the mail list for general questions and other topics.

If you would like to join the workspace, please use the following link:

https://join.slack.com/t/linuxsoftwareraid/shared_invite/zt-22tjz32og-uIKvG3jql5PBilId7Y3MqQ

This link is valid for a limited time. Please let me or Paul know if
you have any
problem with the link.

Special thanks to Paul Luse for initiating this effort and setting up
the workspace!

Best,
Song
