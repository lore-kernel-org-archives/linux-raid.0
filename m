From: Kenneth Aar <kenneth@grafikern.no>
Subject: mdadm what does it mean
Date: Thu, 20 Mar 2008 00:01:00 +0100
Message-ID: <47E19B2C.2040901@grafikern.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I am using mdadm to manage my RAID arrays, but cant seem to find an easy
to understand or concise explanation of what the different parameters
mean when I write:
cat /proc/mdstat in the terminal.

The ones I can't even guess are:

super
bitmap
pages
chunk

Could someone please point me to such a place that will tell me this, or
if you are blessed with fortuitous amounts of time explain it to me in
an email.

My output when I write cat /proc/mdstat today is:
--------

Personalities : [raid1]
md0 : active raid1 sda1[0] sdc1[1]
      488383864 blocks super 1.0 [2/2] [UU]
      bitmap: 2/466 pages [8KB], 512KB chunk

md3 : active raid1 hdb4[0] sdb4[1]
      183711232 blocks [2/2] [UU]

md1 : active raid1 hdb2[0] sdb2[1]
      104320 blocks [2/2] [UU]

md2 : active raid1 sdb3[0] hdb3[1]
      10490372 blocks super 1.0 [2/2] [UU]
      bitmap: 0/161 pages [0KB], 32KB chunk

unused devices: <none>
--------
Any help or pointers appreciated. I tried reading through the man pages
but I am not any wiser. Or it could be that I just missed the relevant
sections.

-- 
Mvh
Kenneth Aar
Grafikern
@:       kenneth@grafikern.no
Nett:    http://www.grafikern.no
Fasttelefon(IP-telefon):  62 11 17 01
Mobil: 92 89 99 89 Faks: 92 57 57 25
