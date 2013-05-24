From: Andrea Bolandrina <andrea.bola@yahoo.it>
Subject: Best size partition for a mdadm array
Date: Fri, 24 May 2013 10:25:11 +0100
Message-ID: <CAOsORH9X6L+EZY5DEDfwbWkHPgL6Oz9yGC1JWf0nejLckVJg=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi All,

In choosing the right size for a mdadm array the manual sais:
"Sometimes a replacement drive can be a little smaller than the
original drives though this should be minimised by IDEMA standards.
Such a replacement drive will be rejected by md.
To guard against this it can be useful to set the initial size
slightly smaller than the smaller device with the aim that it will
still be larger than any replacement."

I want to do a 5x2TB md (raid 6) array .
Could you advise me how "slightly smaller" should my partitions be?

100MB smaller than the actual size? 1GB?

Thank in advance for the attention.

Regards,
Andrea
