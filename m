From: Robert LeBlanc <robert@leblancnet.us>
Subject: raid10.c read_balance question
Date: Mon, 21 Nov 2016 15:45:50 -0700
Message-ID: <CAANLjFodaUUZrROncC+uQjWX5pXVxgJ0HWkNunwugQQrp4Kojw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking to improve 'near' layout performance in raid10 and looking
at the code for read_balance, the comments mention that there is a
'next expected sequential IO' sector number stored for the RAID array,
but I don't see such a variable in the struct, nor do I see in
read_balance where that variable is being updated. With such a value,
I could use it (with another variable) to guess if the current
requests are random or sequential enough to take the latency hit to
move drive heads to help parallel the read. This would be a much
simpler route than what I was thinking about previously.

Am I just missing this variable? I would expect it to be in the
r10conf struct, would that be the right place to implement it if
doesn't exist?

Thanks,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
