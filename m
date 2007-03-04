From: "Christian Pernegger" <pernegger@gmail.com>
Subject: mismatch_cnt questions
Date: Sun, 4 Mar 2007 12:22:39 +0100
Message-ID: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

these questions apparently got buried in another thread, so here goes again ...

I have a mismatch_cnt of 384 on a 2-way mirror.
The box runs 2.6.17.4 and can't really be rebooted or have its kernel
updated easily

1) Where does the mismatch come from?
 The box hasn't been down since the creation of the array.

2) How much data is 384? Blocks? Chunks? Bytes?

3) Is the "repair" sync action safe to use on the above kernel? Any
other methods / additional steps for fixing this?

Regards,

C.
