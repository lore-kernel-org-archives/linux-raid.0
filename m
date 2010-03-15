From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Why do arrays start without some components?
Date: Mon, 15 Mar 2010 13:26:27 -0700
Message-ID: <40b437201003151326t39be3b2hc3df6f79802b9b7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a couple of machines on which this is happening now --

When the machine boots, the RAID arrays (RAID 1) start, but each array
only has one component device. I can add the other component again
(using mdadm --add ... ) and the array will sync up, but next time it
boots, I have to do the same once more.

Why is this and how do I fix it?

Simon
