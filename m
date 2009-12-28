From: jin zhencheng <zhenchengjin@gmail.com>
Subject: why md/raid5 dont have bad block remap
Date: Mon, 28 Dec 2009 19:03:28 +0800
Message-ID: <de04351e0912280303m16a6eac6mf0adad8cd48fc188@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, zhenchengjin@163.com
List-Id: linux-raid.ids

hi ,

I think it isn't  complicated for raid5 to add bad block remap.

"bad block remap" is means that if  a bio is written error, we not
fauty the disk, and try to write this bio  to other place which
alloced  for bad block remap.

i dont  know why MD/raid5 add this function ?


THS
