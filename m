From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable I/O
Date: Mon, 2 Mar 2020 00:08:11 -0700
Message-ID: <CAJCQCtTOJrvm7BnyqSSuCUa82ehZbtHgSGaQo1bzcepgdtazSw@mail.gmail.com>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu> <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
 <20200302115141.1e796b7c@natsu> <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c5d8e6d2-a572-5602-6562-795ea52168ac@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

smart also reports for /de/sdc

  40 53 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455


So I'm suspicious of timeout mismatch as well.
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch


Chris Murphy
