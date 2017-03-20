From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: Read data from disk that was part of RAID1 array
Date: Mon, 20 Mar 2017 10:37:36 -0700
Message-ID: <006a01d2a1a0$ac148170$043d8450$@wnsdev.com>
References: <008801d29ea3$3e858000$bb908000$@warren-selbert.com> <000c01d29f74$ae85c230$0b914690$@wnsdev.com> <58CE5AF8.5070907@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58CE5AF8.5070907@youngman.org.uk>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Wols Lists' <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: Wols Lists [mailto:antlists@youngman.org.uk]
> NEVER NEVER NEVER use --create !!!
> 
> 
> Use something like --assemble --force, which will set up a working array
if it can. 

OK, I tried this command but received an error:

mdadm --assemble --force  /dev/md10 /dev/sdc   

"Cannot assemble mbr metadata in /dev/sdc, no superblock"

What command do you suggest...?



> If that had been an old array, with a different offset or superblock or
the like...

by "old" do you mean an array created using a different superblock format
other than 1.2?

Thanks,
Pete

