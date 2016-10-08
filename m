From: Dark Penguin <darkpenguin@yandex.ru>
Subject: Bitmap in RAM?
Date: Sat, 8 Oct 2016 15:54:26 +0300
Message-ID: <57F8EC82.9010804@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After researching write-intent bitmaps for a while, my understanding is 
that they are used only to speed up "re-adding" drives by avoiding a 
full resync, and to enable --write-mostly --write-behind. However, it 
does introduce some pretty heavy load on whatever device it's on, 
especially if it's an internal bitmap, because the head would have to 
fly all the way to the superblock twice per each write. If it's an 
external bitmap, then the device it's on would be too busy just serving 
it to do anything else.

So if I were to place it on a tmpfs, I could eliminate this problem only 
at the expense of being unable to re-add drives after a reboot, right?.. 
I've read somewhere that bitmaps only work correctly on ext2 or ext3 
filesystems, but that probably means that it's not a good idea to put it 
on a filesystem with delayed allocation like ext4 of zfs, otherwise I 
don't understand why - and so I don't know if there would be any problem 
with it running on tmpfs. Is there?..

By the way, Phil, you are a hero! :) I remember that it was you who 
taught me about the "timeouts and scrubbing" problem a year ago, and you 
always explain things so well! You must have a lot of patience and love 
for all people! :)


-- 
darkpenguin
