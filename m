From: Jojy Varghese <jojy.varghese@gmail.com>
Subject: error injection
Date: Wed, 28 Sep 2011 12:48:37 -0700
Message-ID: <CAJD3hpWbkSGeiWDgYHP3ewnw7akoEY-ydoRJKLxwcp8+up5zKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi
 I am trying to dynamically add error injection to my virtual
disk(LVM) for testing+ debugging purpose. I saw "faulty" personality
module in the kernel and was wondering if there was any documentation
on its usage. I am not looking to set up a RAID but a simple mapped
device. So the basic use case is that I need to be able to dynamically
add/remove error sectors and also be able to have granular error
configuration like read error, read+write error etc.

thanks in advance
Jojy
