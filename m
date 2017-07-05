From: Veljko <veljko3@gmail.com>
Subject: Linear device of two arrays
Date: Wed, 5 Jul 2017 17:34:09 +0200
Message-ID: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
Reply-To: veljko3@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a RAID10 device which I have formated using the mkfs.xfs
defaults (Stan helped me with this few years back). I reached 88%
capacity and it is time to expand it. I bought 4 more drives to create
another RIAD10 array. I would like to create linear device out of
those two and grow XFS across the 2nd device. How can this be done
without loosing the existing device's data? I would also like to add a
spare HDD. Do I have to have a separate spare HDD for each array or
one can be used by both of them?

Regards,
Veljko
