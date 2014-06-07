From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 7 Jun 2014 12:26:55 -0600
Message-ID: <6A48B85A-EDC4-49F6-BEC0-E280066ADD0C@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140607075140.277c0880@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

OK the selective offline is done, and now this is damn strange.

Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Selective offline   Completed without error       00%      1212         -

ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
197 Current_Pending_Sector  0x0022   100   100   000    Old_age   Always       -       24

How can there still be pending bad sectors, and yet no error and LBA reported?


Chris Murphy