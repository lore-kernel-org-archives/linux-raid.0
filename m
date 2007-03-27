From: "Dirk Jagdmann" <jagdmann@gmail.com>
Subject: split raid1 into to arrays
Date: Tue, 27 Mar 2007 04:54:47 +0200
Message-ID: <5d0f60990703261954l2bb8c225ocbc3cf66e868723a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello experts,

I have a raid1 array with two drives working. It /dev/md0 built from
/dev/hda and /dev/hdb. Now I'd like to split it into two array with
one drive each (and then later add spares to my two arrays again). I
know that I can remove one drive from the array with: mdadm /dev/md0
-f /dev/hdb -r /dev/hdb , however I'm not sure what the superblock of
/dev/hdb now contains and how I could use the contents of /dev/hdb as
the starting point for my new /dev/md1 array? I did not find anything
in the manpage of mdadm which would provide me an automatic split.

So what are your advises?

-- 
---> Dirk Jagdmann
----> http://cubic.org/~doj
-----> http://llg.cubic.org
