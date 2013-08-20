From: Francis Moreau <francis.moro@gmail.com>
Subject: Accesses to not yet running array
Date: Tue, 20 Aug 2013 16:08:47 +0200
Message-ID: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi,

It looks like a process wait uninterruptibly when it tries to access
an array which is not running yet.

Furthermore once the process is waiting, I can't start/stop the array anymore.

So I need to reboot my system and be sure next time that any processes
don't try to access a not yet running array.

Is that expected ?

Thanks
-- 
Francis
