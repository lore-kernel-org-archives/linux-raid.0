From: Liwei <xieliwei@gmail.com>
Subject: RAID6 grow unexpected results
Date: Fri, 23 Oct 2015 03:47:45 +0800
Message-ID: <CAPE0SYz97qwHaQjgguZbQ3rdxKZjDdS9sg5F5dy10W3GP=U3+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,
    I tried growing a RAID6 array by executing the mdadm --add and
mdadm --grow --raid-devices commands. Usually that should run fine and
I can continue with pvresize.

    This time however, the actual usable raid array size did not
change even though reshape begins. In my confusion, I decided to
reboot. That didn't solve the problem (and apparently the reshape was
interrupted, but mdadm shows the grown array as clean?)

    I then executed mdadm --grow --size=max, which seemed to have
increased the array size, but apparently by too much. Now I'm getting
"attempt to access beyond end of device" errors for each of the
component drives. A new reshape operation has also begun, which I
expect would fail as the array size is now too big.

    What did I do wrong and how can I remedy this?

Liwei
