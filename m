From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: mirrors not forming at reboot (sometimes)
Date: Wed, 4 Nov 2009 11:36:10 -0800
Message-ID: <4877c76c0911041136w3e785290u1a77dbac48c8d380@mail.gmail.com>
References: <ab50889f0911040736j4be43d4eq686402ab0f467126@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ab50889f0911040736j4be43d4eq686402ab0f467126@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John McNulty <johnmcn1@googlemail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As block devices and partitions are detected they are added to a list
(128 entry array unless the patch was back-ported).  The list is then
checked during auto-assembly.

It looks like your second controller is not appearing in the list for
some reason.  You should check earlier messages to see if it's
detected at similar times (possibly enable the netconsole logging (
first search hit:
http://www.mjmwired.net/kernel/Documentation/networking/netconsole.txt
)) and verify the hardware, firmware, and configuration of the second
controller match what you expect.
