From: Chris Pearson <kermit4@gmail.com>
Subject: with raid-6 any writes access all disks
Date: Wed, 26 Oct 2011 16:01:19 -0500
Message-ID: <CAGtzr3c65BXDfWZq4ejKwCZv7hPZmdCpvQP17RgFS-Vrn2YF5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In 2.6.39.1, any writes to a raid-6 array cause all disks to be
accessed.  Though I don't understand the math behind raid-6, I have
tested on LSI cards that it is possible to only access 3 disks.
