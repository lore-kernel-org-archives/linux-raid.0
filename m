From: d tbsky <tbskyd@gmail.com>
Subject: caculate chunk size for the future
Date: Wed, 21 Jun 2017 00:43:40 +0800
Message-ID: <CAC6SzHKGpoxTKNdMheB65j5QTGpYDBh2mUQUQyqhW+5O4=1uZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi:
    I have a 4 disk software raid6. I found chunk size 512k give me
best performance for my workload.

    if I grow up the raid to 32 disks, may I assume chunk size 64K
will give me similar performance? or there will other impact when I
grow the disks in the future?

  I saw discussion about internal bitmap hit the performance for 20
disks raid10. is raid5/6 ok under the same situation?

     thanks a lot for help!

Regards,
tbskyd
