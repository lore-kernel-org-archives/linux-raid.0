From: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.ac.be>
Subject: mdadm.conf questions
Date: Thu, 15 May 2003 12:13:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC3685E.3010202@cc.kuleuven.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When I run "mdadm --detail --scan", the command outputs information about the devices in the array on a separate line:

# mdadm --detail --scan
ARRAY /dev/md3 level=raid0 num-devices=3 UUID=fc5d996b:15107473:e3e819c9:6829a450
   devices=/dev/md0,/dev/md1,/dev/md2
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=32d034b8:e93cc8c7:f6335e14:829aefee
   devices=/dev/sde,/dev/sdh
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=4efa3017:9dc3fa9b:6f4acac4:e1944bec
   devices=/dev/sdd,/dev/sdg
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=1d078c62:2b90a2c3:1ec1d0af:75600395
   devices=/dev/sdc,/dev/sdf

1. When I redirect this output to '/etc/mdadm.conf, should I then edit the file to join the line listing the devices to the one defining the ARRAY?
2. Should the devices tag be there at all?  sd[c-e] are on a separate bus from sd[f-h].  If I add more devices to the first bus, sd[f-h] will be renamed.  Won't that confuse the md driver? 
3. should I add /dev/md[0-2] as DEVICE in /etc/mdstat.conf?

Kind regards,

Herta



