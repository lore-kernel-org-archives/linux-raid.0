From: Chris Murphy <lists@colorremedies.com>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 15:14:36 -0700
Message-ID: <CAJCQCtRSnFFjFOtKmn3Cobni0v1QSNedOxnjzVZFq54e4dF1TA@mail.gmail.com>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net> <1cf640fc-c6ee-25e8-8aee-9cf8025f9f4d@turmel.org>
 <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRdXJkaLdzDi4JuDJbjkSqX-mUj+kjrHtH6JNTLCenuuQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

An exception to the single partition "rule" is with UDF. In order to
get a fully cross platform supported UDF volume, it needs to own the
entire physical block device. It's quite a bit more sane to use as a
cross platform volume format than FAT32 or exFAT, for sticks or
drives.


Chris Murphy
