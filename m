From: Marcus Sorensen <shadowsor@gmail.com>
Subject: quick question about write-intent bitmap
Date: Wed, 30 Nov 2011 23:34:13 -0700
Message-ID: <CALFpzo6wwtmnyCGW+4OkZL=6=0OFPV3STREq56_5jJt9z_qX2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would appreciate being pointed to any sort of in-depth documentation
on how the write intent bitmap works. To make my question quick, I'm
wondering how the write-intent bitmap holds up to writeback caching.
It seems like md would assume that the cached writes had made it to
disk, and only rebuild writes that happened since the disk was
removed, leaving an inconsistent array.
