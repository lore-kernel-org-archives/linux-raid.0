From: hui jiao <simonjiaoh@gmail.com>
Subject: Are piggybacking of write and redirection of read available in md
 driver now?
Date: Tue, 16 Oct 2012 13:44:45 +0800
Message-ID: <CAEuG+X+b6wr=291NbH5=LR0gSSBVHG_JcWSgk7_SKnBtRaxHrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

there were two optimizations-redirection of reads and piggybacking of
writes-which first introduced in paper "Performance Analysis of Disk
Arrays under Failure" 16th VLDB conference 1990.

redirection of reads: the user accesses to data that has already been
reconstructed are serviced by (redirected to) the replacement disk,
rather than invoking on-the-fly reconstruction as they would if the
data were not yet available.
piggybacking of writes: the user reads that cause on-the-fly
reconstruction also cause the reconstructed data to be written to the
replacement disk.

have these two features been implemented in md driver now? if so,
where i can find them? if not, is there any plan on them?

Thanks
