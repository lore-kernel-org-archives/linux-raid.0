From: Song Liu <songliubraving@fb.com>
Subject: Re: mdadm - raid6 best practices ?
Date: Fri, 22 Sep 2017 11:26:07 -0700
Message-ID: <20170922182607.1977620-1-songliubraving@fb.com>
References: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMNNMLHLA8mEEKpX8UAXgZPYXyL+mhSBC74K_azC25z=+VAc7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: nkshirsa@redhat.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

I would say this is a tradeoff between space overhead (2 parity disks per
array) and data reliability (mean time before data loss, MTBDL, or MTTF).
Space overhead is easy to calculate. For MTBDL, there are various of
documents online, for example:

https://jontse.com/courses/files/cornell/ece5730/Lecture24.pdf

For your questions:

> a) recommended number of disks included in RAID array set?
I would personally recommend 12 to 15 HDDs per array.

> b) Is it possible to include all 84 disks in one array and leave 2 of
them as host spare?
It is possible, but not recommended. 84 disks per array really hurts
reliability.

> c) Is there a raid6 best practices document to refer to ?
I am not aware of such documents.

Hope these help.

Song
