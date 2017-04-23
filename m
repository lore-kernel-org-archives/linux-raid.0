From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Recover array after I panicked
Date: Sun, 23 Apr 2017 11:47:34 +0200
Message-ID: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Here's the story:

I started with a 5x6 TB raid5 array. I added another 6 TB drive and
started to grow the array. However, one of my SATA cables were bad and
the reshape gave me lots of I/O errors.

Instead of fixing the SATA cable issue directly, I shutdown the server
and swapped places of 2 drives. My reasoning was that putting the new
drive in a good slot would reduce the I/O errors. Bad move, I know. I
tried a few commands but was not able to continue the reshape.

I then took out the server from the rack and replaced the SATA cable. No
more I/O errors, but at this point I am unable to recreate the array.
This is when I really started to panic. After multiple attempts at
rescuing the array, I tried running the Permute_array.pl script [1] with
some local modifications to additionally try different chunk sizes. So
far I've had no luck.

I don't remember what commands I have run.
I have the OS on a separate drive, i.e. /var/log and /etc is intact.
raid metadata version is 1.2.
Ubuntu 16.04.02 LTS
Kernel 4.4.0-72-generic
mdadm 3.3


Is there any help you can offer?


[1] https://raid.wiki.kernel.org/index.php/Permute_array.pl



