From: Chris Worley <worleys@gmail.com>
Subject: Load-balancing mirrors w/ asymmetric performance
Date: Sun, 4 Oct 2009 13:40:37 -0600
Message-ID: <f3177b9e0910041240h4dba8771vb5ba07216c9c8189@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When you mirror two devices, they may not have the same performance.
For example, if one device is local and the other remote.

There's nothing you can do about writes, as everything needs written.

But, reads shouldn't be split 50/50: they should be balanced depending
relative performance of each mirror to optimize overall read
performance.

Chris
