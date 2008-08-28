From: "Don Dupuis" <dondster@gmail.com>
Subject: 2.6.18 very slow sync to disk with ext3 fs on an md raid10 array
Date: Wed, 27 Aug 2008 22:03:02 -0500
Message-ID: <632b79000808272003m58cc5b32i8f44b563a4ba89cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 12 drive system running 2.6.18.8 with a 11 drive md array.
This array is setup with raid10 and a combination of ext3 and ext2
filesystems. The issue I am having is this. I transfer a 180MB file
with scp to the ext3 filesystem. When this is complete, I will then do
a sync to make sure it is written to disk. The problem is that it will
take 6 MINUTES for the sync to complete. If I do the same thing to the
ext2 filesystem, it will take about 6 seconds. I know that 2.6.19
kernel solves my problem, but the project I am working on requires
2.6.18. I am trying to figure out which patch or patches that went in
to 2.6.19-rc1 fixes this. PLease give me suggestions. I will give
needed data that will be asked for. One more thing, this is an X86_64
kernel on an Intel quad core processor. The disk controller is an LSI
sas controller.

Thanks

Don
