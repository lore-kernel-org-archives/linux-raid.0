From: "Jonathan Terhorst" <terhorst@gmail.com>
Subject: Shrinking a RAID1--superblock problems
Date: Tue, 12 Dec 2006 12:53:01 -0500
Message-ID: <a45f4c9c0612120953k1d527734u921a5ce4db3db43f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I need to shrink a RAID1 array and am having trouble with the
persistent superblock; namely, mdadm --grow doesn't seem to relocate
it. If I downsize the array and then shrink the corresponding
partitions, the array fails since the superblock (which is normally
located near the end of the device) now lays outside of the
partitions. Is there any easier way to deal with this than digging
into the mdadm source, manually calculating the superblock offset and
dd'ing it to the right spot?

-- 

Jonathan
terhorst@gmail.com
