From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Question about raid5 disk recovery logic
Date: Sun, 1 Jul 2012 10:08:40 +0300
Message-ID: <CAGRgLy7uJAzTwnuvgXgH=SnKdVBqgPF41eM0N-CYn8bS2BzW9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi everybody,
I am trying to understand what happens when raid5 is recovering a
disk, and a write comes to a stripe that has not been recovered yet.
Does md first reconstruct the missing chunk and then applies the
write, or first the write is applied as if the array is still degraded
(and not recovering), and only later the missing chunk is
reconstructed (when the md_do_sync() loop gets to this area)?
I am looking at the stripe handling logic (kernel 2.6.38), can anybody
pls point me at the path that handle_stripe5() takes in that case?

Thanks,
Alex.
