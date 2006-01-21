From: Andy Gajetzki <andy.gajetzki@gmail.com>
Subject: linear raid space utilization
Date: Sat, 21 Jan 2006 00:12:48 -0700
Message-ID: <cc5782160601202312y25bc339cvcb1973c24208da3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,  I recently had a disk go bad in a linear RAID built with
mdadm. The particular disk that failed was the last  device of the
RAID. I am curious about how  devices are utilized in a linear RAID.
Would the md be filled sequentially from device 1 upto 5? In other
words, what are the odds that the last disk was "empty" when it went
south?

Thanks for your time,

Andy
