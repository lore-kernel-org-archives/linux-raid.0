From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: raid1 read io balancing algorithm
Date: Thu, 8 Aug 2013 11:27:37 -0300
Message-ID: <CAH3kUhF+JwO6KX2sWE+psVbBugx3nGfTiB_-jAvoPCj2vr77dw@mail.gmail.com>
References: <20130808110452.464E2097@centrum.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130808110452.464E2097@centrum.sk>
Sender: linux-raid-owner@vger.kernel.org
To: struhlo@centrum.sk
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi, from what i remember, it's done only with device "last position"
AKA "disk head position"
the device with head position near to position being read is "selected"
on sequencial reads, the last used device is used, considering that
for sequencial reads a single disk is faster, because we don't waste
3ms to positioning head to sector, that's near true if you don't have
diferent devices speed (7200rpm + 10000rpm + 15000rpm + ssd)

the best source of this information is source code of raid1.c
it's a function (i don't remember the name, but something like read_balancing)

sorry many emails the mail list denied HTML emails
