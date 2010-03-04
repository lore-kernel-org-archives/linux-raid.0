From: Alex Boag-Munroe <boagenator@gmail.com>
Subject: I am an idiot.
Date: Thu, 4 Mar 2010 11:30:36 +0000
Message-ID: <68c4f7e31003040330s21b6059ex6859247ff67b43e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys...

Yes I am an idiot.  I was changing the chunk size of my RAID5 array
last night from 64kb to 256kb and left it running overnight.  During
the night we had a power outage.

This is where the idiot part comes in.  The backup file is on a
filesystem that's part of the RAID5 array, so obviously I am unable to
start it.  I completely forgot the filesystem I specified for
--backup-file was part of the same array.

Once you're all done pointing and laughing, can you let me know if I
am totally screwed?  I've a lot of data here that I -really- don't
want to lose...

Please help..

Idiot.

--
Alex Boag-Munroe

Lack of planning on your part does not constitute an emergency on mine.
