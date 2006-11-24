From: "Dragan Marinkovic" <marinkovic.dragan@gmail.com>
Subject: Linux RAID version question
Date: Thu, 23 Nov 2006 17:49:25 -0800
Message-ID: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have two issues with metadata version 0.9 which I'm hoping are
resolved with metadata version 1:

1. endianes issue with metadata 0.9 (can't swap the RAIDs built on LE
and BE machines)
2. RAIDs built with metadata version 0.9 does not always continue
rebuilding where they left off when last stopped (specifically on the
clean shutdown while the raid is still rebuilding).

I think that both issues are resolved with metadata version 1 in
kernel 2.6.18 . Is this correct or there are patches to be applied for
both issues?

Is the subversion of metadata version 1 important (there are 1, 1.0,
1.1 and 1.2)? If it is, which one is the best to use from the
stability point of view?

I would appreciate any help.

Cheers,
Dragan
