From: Felipe Alvarez <felipe.alvarez@gmail.com>
Subject: Re: Fwd: Majordomo results: Re: Majordomo results: .
Date: Wed, 24 Feb 2010 19:45:31 +1000
Message-ID: <e4ae6451002240145i704454cdt94435913054c6122@mail.gmail.com>
References: <e4ae6451002240054q4cb517a3m4715046647e2d68c@mail.gmail.com>
	<61113.94788.qm@web51303.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <61113.94788.qm@web51303.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The beauty of that being that when all the drives
> have been retired/failed and the smallest partition
> size is now 500GB or whatever you can
> --grow=max and get that unused space.
>
Thanks. That's a good idea, because I would eventually like to make
the array larger than it is as the drives get replaced, one at a time.
Would the command be:
$ mdadm --grow /dev/md0 --size=max DEVICE1 DEVICE2 DEVICE3 DEVICE4

Felipe
