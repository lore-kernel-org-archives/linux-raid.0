From: "Claudiu Cismaru" <claudiu.cismaru@gmail.com>
Subject: RAID5 failure due to changing, by mistake, of a good disk
Date: Fri, 9 Mar 2007 17:52:50 +0200
Message-ID: <177775fa0703090752n49374b64wcc9f1f54e2eba6d9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had a RAID 5 made from 3 hard disks. One of the hard disk started to
have bad blocks (to fail), several weeks ago. I didn't had time to
change it, until today.

But from mistake, instead changing Primary Master (hda - that was
failing), I've replaced the hdc (second disk in the array). After
starting the system, the array tried to get online, it found the new
hard disk and marked it as spare disk. I think it started to resync
the information to the spare, but the failing disk had error and the
array didn't got online, giving I/O error. I've seen on the screen the
errors and I realized that I changed the wrong disk, so I placed the
old good disk in place and placed the new disk in the bad one's place
(like I had to do first time). But, the array seen the old good disk
(with correct data) as spare disk, also.

So, I can't bring the array online with one good remained disk and one
spare. The "spare" disk, that was the good one, has the correct data
information on it, only that it's seen as spare one. There is a way to
make the md to see it as active disk? Modifying the super block or
other way?

On this array I have a lot of LVs and they contains 4 virtual machines
with a lot of information on it.

Can you help me with some advice?

Thank you,

-- 
  Claudiu Cismaru
  Network/System Administrator
