From: "d binderman" <dcb314@hotmail.com>
Subject: raidtools-1.00.3-234 bug report
Date: Thu, 17 Nov 2005 12:15:56 +0000
Message-ID: <BAY107-F3E87D7A3C696C702B75979C5F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello there,

I just tried to compile package raidtools-1.00.3-234 with the Intel C 
compiler.

It said

scsi.c(277): warning #175: subscript out of range

The source code is

    sg_dev->revision[5] = '\0';

but

../BUILD/raidtools-1.00.3/scsi.h:    char revision[5];

Suggest code rework.



Regards

David Binderman

_________________________________________________________________
MSN Messenger 7.5 is now out. Download it for FREE here. 
http://messenger.msn.co.uk

