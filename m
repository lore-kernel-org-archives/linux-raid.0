From: Peter Daniel <pdaniel@cardaccess.com.au>
Subject: Automatic notification of failure in softRAID array?
Date: Tue, 9 Jul 2002 17:18:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A7F6E3C5F6C5D211A85200104B2EBCD2317E37@mail.cardaccess.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I am running a server here with Red Hat 7.1, 2.4.18 kernel, and softRAID set
up on all but the root filesystem.  This server is meant to sit on a remote
site where we won't be able to monitor it all the time, So I would like it
to notify me if one of the disks in the RAID-1 array fails.  Is there any
integrated way of doing this, or will I need to hack together a script to
periodically parse the contents of /proc/mdstat and act accordingly?

Please reply to this address, as I am not a member of the mailing list and I
can not regularly check the archives.

Thanks for any assistance you may be able to render.


--
Peter Daniel

peter@cardaccess.com.au
Card Access Services Pty Ltd
http://www.cardaccess.com.au


