From: Rob Emanuele <rob@emanuele.us>
Subject: RAID 10 Repairs
Date: Sun, 2 Jun 2013 19:07:14 -0700
Message-ID: <CAE98Ua_Js7wpfkT7wAZhm79Y46t4Fqtfx3752SUO_+H-3jqqcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings!

So, I've been looking at repairing my RAID 10 software array. I have a
failing drive with incrementing SMART errors. I went to replace that
drive with a new drive.  The failing drive is 250,059,350,016 bytes
while the batch of new drives I bought as spares are 250,000,000,000
bytes.

When I add the new drive it tells me the drive is too small.  Is there
a way to shrink the array so that new new drives (any any other
replacement drives around 250G) will work in the array?

Hearsay: I've heard there may be a way to convert the RAID 10 to a
RAID 0 but I haven't had any success.

Thanks for your help!

--Rob
