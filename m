From: Ionut Cadariu <ionut.cadariu@gmail.com>
Subject: some raid questions
Date: Thu, 7 Feb 2013 15:49:18 +0200
Message-ID: <CAANkY-n1ZhcU+A2zf1X9mJJURoEoj8=n9S4Kct5Y+iQA1zZ=dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have some problems understanding the following situation (it's a
real situation that occurred  one of my friends had this but couldn't
explain me) so if anyone can point me to the documentation or explain
me will be great:

Let's say md3 with members: sda6 and sdb6

- if there are some file system errors on array md3, and I'll create a
degraded array with only sda6 then run fsck ..what happens if I'll add
sdb6 to the array ...first i don't understand from what member will
sync begin ...sda6 or sdb6...then if sync will be from sdb6 errors
remain

- if the sync will be done from sda6 ...will errors on sdb6 get fixed
without fsck
- if the sync will be done from sdb6 ....i think will get synced with
errors ...so sda6 will have errors

If i'm wrong or you can help me please reply...
My friend that had this situation started to sync data to another
disks so he can't help me with this.
