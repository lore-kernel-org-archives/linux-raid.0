From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: Read data from disk that was part of RAID1 array
Date: Fri, 17 Mar 2017 16:17:42 -0700
Message-ID: <000c01d29f74$ae85c230$0b914690$@wnsdev.com>
References: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008801d29ea3$3e858000$bb908000$@warren-selbert.com>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, pete@wnsdev.com
List-Id: linux-raid.ids



> From: Peter Sangas [mailto:pete@wnsdev.com]
> I have only one disk from a RAID1 array and I would like to read data from
one of the
> partitions.  This there a way to mount this and read the data?

This worked for me:

mdadm --create /dev/md10 -l 1 -n 2 /dev/sda missing     md10 is chosen to
avoid conflicts with existing RAID1

mount /dev/md10 /mnt 

