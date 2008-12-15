From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid1 recovery: reads and writes
Date: Mon, 15 Dec 2008 07:45:38 -0600
Message-ID: <cccedfc60812150545s7159f0a2x2fa7f36ecf8d9c60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a software raid1 which underwent a recovery recently.
While it was recovering, I could not understand why I was seeing an
equal amount of *read* I/O as write I/O to the device the raid1 was
recovering to. That's to say, the raid1 was rebuilding on to a spare
but instead of just writing I was seeing (nearly exactly) the same
amount of read I/O as write I/O. The non-spare device was getting
almost exclusively read I/O as expected. Why was the spare getting any
read I/O at all?

-- 
Jon
