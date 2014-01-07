From: Marcus Sorensen <shadowsor@gmail.com>
Subject: write-mostly
Date: Tue, 7 Jan 2014 11:22:55 -0700
Message-ID: <CALFpzo66xPsBNkO6Fs5Zsegf3=rbKgRfxzyyuXtmytgYXirZkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've been experimenting with write-mostly a bit more (I've used it off
and on over the years), and I'm reminded of one thing I've always
found curious. It doesn't seem to really stop reads from the slower,
write-mostly disk. If I have one disk that can do 500MB/s reads and
another that can do 25MB/s reads, I get 500MB/s reads in degraded mode
without the slow disk, ~25-30MB/s for the clean array without
write-mostly, and ~40-50MB/s reads with write-mostly flagged on the
slow disk.  Is this the expected behavior?
