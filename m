From: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Subject: non-optimal RAID 5 performance with 8 drive array
Date: Tue, 01 Mar 2005 14:24:47 +0100
Message-ID: <42246D1F.3070407@variant.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all

I have a RAID 5 array consisting of 8 300GB Maxtor SATA drives 
(6B300S0), hooked up to a Asus A8N-SLI deluxe motherboard with 4 NForce4 
SATA ports and 4 SiI 3114 ports.

see [3] for a description of what I did and more details.

each single disk in the array gives a read performance (tested with dd) 
of about 62MB/s (when reading the first 4GiB of a disk).

the array (reading the first 8GiB from /dev/md0 with dd, bs=1024K) 
performs at about 174MiB/s, accessing the array through LVM2 (still with 
bs=1024K) only 86MiB/s.

my first conclusion was to leave out the LVM2 of the loop and directly 
put a file system on /dev/md0.

however, when reading Neil Brown's article [1], I got the impression 
that my system should perform better, given the fact that each disk has 
a transfer rate of minimally 37MiB/s, maximally 65MiB/s [2].

or is there a flaw in my argumentation and the current performance is 
normal? are at last the controllers saturating?

any suggestions are welcome.

regards
nicola

[1]: http://cgi.cse.unsw.edu.au/~neilb/01102979338
[2]: http://www.storagereview.com/articles/200410/200410087B300S0-2_2.html
[3]: http://variant.ch/phpwiki/WikiBlog/2005-02-27
