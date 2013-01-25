From: Asif Iqbal <vadud3@gmail.com>
Subject: Failing to grow raid10 with one larger disk
Date: Thu, 24 Jan 2013 19:33:01 -0500
Message-ID: <CAOHBbgU5Uf+eD=O7_0K1AKn_t+RcdaeAQabf9XSST8qtcbaAsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Replaced one of the 6 72G disks from raid10 with a 300G disk.

But failing to grow the md10

# mdadm --grow /dev/md10 --size max
mdadm: raid10 array /dev/md10 cannot be reshaped.

What gives?

--
Asif Iqbal
PGP Key: 0xE62693C5 KeyServer: pgp.mit.edu
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
