From: Veedar Hokstadt <veedar@gmail.com>
Subject: Is there a tool to examine raw metadata?
Date: Wed, 20 Nov 2013 13:26:10 -0500
Message-ID: <CANb3qHfWJp4ana76ap8YBaVJfCfmUS8FUATYS9YrAgJ9JrfLCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings,
Consider a 3 drive RAID5 where each drive has lost it's partitioning
info. Running mdadm -E does not find a superblock. But using hexedit
an mdadm superblock can be found in tact near the end of each drive.

Is there perhaps a tool I can point at the superblock to decode it? Or
trick mdadm into reporting the contents of the superblock?

I know I can look at the superblock format doc and translate it by
hand but I was hoping for an easier way.   Thanks for any help.  -V
