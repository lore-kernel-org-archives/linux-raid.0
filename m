From: hank peng <pengxihan@gmail.com>
Subject: sector I/O error cause disk to be "faulty" in raid5
Date: Mon, 6 Jun 2011 21:28:22 +0800
Message-ID: <BANLkTikpcH=navhOAFA2Jw+CT+rQfpOwcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, everybody:
In current raid5 implementation, if a r/w error occured at some
specific sectors on a disk, the disk will be labeled as "faulty".
Here, I want to say in most cases, this is failure indication of those
sectors not the whole disk. Should we make some changes to be more
reasonable?

-- 
The simplest is not all best but the best is surely the simplest!
