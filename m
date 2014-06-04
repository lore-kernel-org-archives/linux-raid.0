From: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Subject: [RFC PATCH 0/4] md/mdadm: introduce request function mode support
Date: Wed,  4 Jun 2014 19:09:58 +0200
Message-ID: <1401901802-16296-1-git-send-email-sebastian.riemer@profitbricks.com>
References: <20140602202050.14903534@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140602202050.14903534@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Patches apply to linux v3.15-rc8 and mdadm master commit 8a3544f895.

Florian-Ewald Mueller (3):
      md: complete bio accounting and add io_latency extension
      md: introduce request function mode support
      md: handle IO latency accounting in rqfn mode

Sebastian Parschauer (1):
      mdadm: introduce '--use-requestfn' create/assembly option
