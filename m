From: Fabien Bourigault <dradge@gmail.com>
Subject: Check / Automatic repair
Date: Mon, 21 May 2012 12:09:47 +0200
Message-ID: <CAFYuN7qTy5Apj265N6PiyvbU5QmS7=ry+ofi=vHjzDfsf7uh5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I was reading the kernel md.txt documentation and found that couple of
sentences about sync_action :

496        check         - A full check of redundancy was requested and is
497                        happening.  This reads all block and checks
498                        them. A repair may also happen for some raid
499                        levels.


What levels/configurations are affected by the "A repair may also
happen for some raid levels." sentence ?

Regards
