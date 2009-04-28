From: Kunal Kushwaha <kunal.kushwaha@gmail.com>
Subject: Query regarding stripe management in linux md-raid
Date: Tue, 28 Apr 2009 22:02:18 +0800
Message-ID: <fbae8f520904280702h736197d6ibfdf0212bf1923d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am trying to put Linux raid in Box with 256 MB of RAM. The kernel is
compiled with non-swappable memory management option. I looked into
raid5.c and found, it allocates one page for each chunk.  I am using 5
disks for 64k chunk size. considering my kernel is within 30 MB.

1. If one page is allocated for one chunk instead of actual buffer
size, isn't memory lot of memory is wasted?
2. It will restrict the no. of stripes in memory (in case of
non-swappable memory, no will be very less) will effect performance of
IO badly.

Please correct me, if I am wrong, also any suggestion to overcome this
problem is most welcomed.

-- 
Thanks in Advance,
Kunal Kushwaha--
