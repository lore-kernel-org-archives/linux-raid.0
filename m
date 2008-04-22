From: "Billy Crook" <bcrook@advancedclustering.com>
Subject: Multipath behavior
Date: Tue, 22 Apr 2008 12:48:14 -0500
Message-ID: <135ea5430804221048g2e0ba8ci3d96a23ed9afdea5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am considering implementing multipath for iSCSI.  Documentation is
scant though, so I thought I'd ask my questions here.

Does mdadm multipath loadbalance IO, or just allow for failover, or both?
Is there any advantage to notifying mdadm pre-emptively if possible
before a path goes down?
I assume bringing a path online has to be done manually like adding a
disk.  Can spare paths be used?

The kernel involved is 2.6.18-53.1.14.el5.

Thank you for your time.
-Billy Crook
