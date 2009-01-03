From: "Jeff Rippy" <jrippy@gmail.com>
Subject: Fwd: Raid 5 --grow to fewer, larger drives
Date: Sat, 3 Jan 2009 17:27:49 -0600
Message-ID: <de6d3ea90901031527x4af0dfcfm28f2d8890698a931@mail.gmail.com>
References: <de6d3ea90901031521va35b7b5uf3050995561592c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de6d3ea90901031521va35b7b5uf3050995561592c0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I too am looking at this.  My current setup is 4x 500GB drives and I
want to move to 3x  >=1TB drives.
My usable space should increase from 1.5TB to >= 2TB with this move if possible.

I'm fairly new to linux-raid in general but I know you can replace
drives with bigger ones.  You just can't use their space until all
drives in the array are of that size.  So I'm thinking of replacing 3
of the 500's with the 1 TBs.  Then fail and remove the 4th drive
(assuming enough free space) and somehow forcing a reshape on the
remaining 3 drives.  Not sure if that is possible but I can't imagine
why it wouldn't be.  After the resync, finally grow to the new size
and be done.

Can someone tell me if this is even possible?  I saw the one reply in
Nov. to Alex's email but I don't have another machine to swap the
disks too.
