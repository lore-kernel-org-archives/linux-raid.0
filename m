From: "dr_snafu" <dr_snafu@earthlink.net>
Subject: musical chairs
Date: Wed, 22 Sep 2004 15:00:46 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001501c4a0d6$7818e740$7000a8c0@gordo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hello, 

i have a disk with data on it /dev/hdc, 
    and a brand new empty disk /dev/hdb. 

want to set up raid 1 without moving data off hdc. 
    it very large and i have no where to put it

will this work?: (notice # of devices)

mdadm --create --verbose /dev/md0 --level=1 
        --raid-devices=1  /dev/hdb

will this create an unmirrored raid 1 setup? 
    can i start and mount md0?
    then copy the data from hdb to md0?

then?:

mdadm /dev/md0 --add /dev/hdc


seems too good to be true, 
    maybe you know another way?

jd
