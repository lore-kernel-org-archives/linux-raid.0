From: John McMonagle <johnm@advocap.org>
Subject: Possible failures in raid5?
Date: Sun, 26 Dec 2004 19:14:49 -0600
Message-ID: <41CF6209.2050209@advocap.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I am  building a  server for backing up our other servers.

For now have 3 200gb sata drives.
Using debian sarge with 2.6.8 kernel.
Will have a ups and set to shut down on power failure.
I am  concerned what will happen if the computer dies while writing a strip.

Is it possible that the stripe will be corrupted?
If so will the  the rest of the raid array be OK?
if so is there anything one can do  about it?

Thanks

John
