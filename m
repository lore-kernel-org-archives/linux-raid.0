From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 20:20:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <002501c44837$64699a20$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm aiming at a very similar setup as what you're talking about. Whether or
not you put your root on the raid is up to you. Personally, I don't, and I
have my raid mounted as /home. Anyways, your mobo should support two drives,
and each additional controller should support two drives. Thus, with one
addon controller, you can have 4 drives. With 200GB drives, that's 600GB of
space doing RAID 5. In my experience, adding more drives to an array is
extremely easy, but it is dangerous. It is possible to lose data even if you
do follow the steps verbatim, although I've done it 3-4 times myself with no
trouble. First, you must use raidreconf to grow the array onto the new disk,
then you must use resize2fs to expand the filesystem to fill the array.
Backing up during this process is highly recommended!

I personally don't use a hot spare, and I haven't had any trouble with drive
failure since I got rid of all my IBM drives. I did have a run in with a WD
drive that needed a firmware update else it dropped out of the array
periodically, though. A hot spare is something to take into consideration.
Also, you might look into some sort of monitoring script. If you don't
monitor the array, you could lose one disk and go months without ever
knowing. Something that would email you would be ideal.


