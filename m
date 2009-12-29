From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Raid 5 to 6 is it do-able/safe?
Date: Tue, 29 Dec 2009 03:55:54 -0800 (PST)
Message-ID: <305721.15040.qm@web51302.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I run a 6 drive array with a multitude of drive sizes with 1 drive spare and 1 bay left.

I am running out of space! I want to take my drives past 1TB per drive (currently 500GB~1TB) but want RAID 6 for when the array goes to > 1TB per drive (coming soon)

I have deliberately kept 1 drive as a spare to give me the option of going to raid 6. Is this something mdadm can do? I have 

mdadm - v3.1.1 - 19th November 2009

I run gentoo with kernel 2.6.22-gentoo-r8

Don't know if it is relevant but have lvm on top

LVM version:     2.02.56(1) (2009-11-24)
Library version: 1.02.40 (2009-11-24)
Driver version:  4.11.0


I have seen talk on Neil's site, just not sure if the support is definately there.

If it is would i run something like this

mdadm --grow /dev/md4 --level=6 --raid-disk=7

to convert my 6 drive +1 spare raid 5 to a 7 drive raid 6? 


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing it with jon AT eHardcastle.com
***********

-----------------------


      
