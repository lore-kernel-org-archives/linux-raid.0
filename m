From: Hans Kraus <hans@hanswkraus.com>
Subject: How do I set 'write-behind' on existing array?
Date: Mon, 20 Oct 2014 14:33:31 +0200
Message-ID: <5445011B.8040008@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I want to expand an existing root array with an SSD. For that purpose I
try to set firstly 'write-behind' on that array. Afterwards I will add
the SSD, remove the HDs and re-add them with 'write-mostly'. On that
array is the root filesystem, therefore stopping is no option. In
 >/home/kraush/work/mdadm/mdadm< is the latest mdadm version from git.
I tried:
-----------------------------------------------------------------------
root@elefant:/home/kraush/work/mdadm/mdadm# ./mdadm --manage 
--write-behind=4096 /dev/md4
mdadm: :option --write-behind not valid in manage mode
root@elefant:/home/kraush/work/mdadm/mdadm# ./mdadm --grow 
--write-behind=4096 /dev/md4
mdadm: no changes to --grow
-----------------------------------------------------------------------
What is the correct syntax?

Regards, Hans
